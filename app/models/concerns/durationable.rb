module Durationable
  extend ActiveSupport::Concern
  include ActionView::Helpers::DateHelper

  FLOAT = '(?:\d*\.)?\d+'

  PATTERNS = {
      years: "(?<years>#{FLOAT})y(?:ears?)?",
     months: "(?<months>#{FLOAT})mo(?:nths?)?",
       days: "(?<days>#{FLOAT})d(?:ays?)?",
      hours: "(?<hours>#{FLOAT})h(?:ours?)?",
    minutes: "(?<minutes>#{FLOAT})m(?:in(?:ute)?s?)?",
    seconds: "(?<seconds>#{FLOAT})s(?:ec(?:ond)?s?)?"
  }

  PATTERN = /\A#{PATTERNS.map{ |_, pattern| "(?:#{pattern})?" }.join}\z/i

  STRINGS = {
      years: -> (years)   { "#{years  } #{I18n.t 'activerecord.durationable.year',  count: years }" },
     months: -> (months)  { "#{months } #{I18n.t 'activerecord.durationable.month', count: months}" },
       days: -> (days)    { "#{days   } #{I18n.t 'activerecord.durationable.day',   count: days  }" },
      hours: -> (hours)   { "#{hours  }h" },
    minutes: -> (minutes) { "#{minutes}min" },
    seconds: -> (seconds) { "#{seconds}s" }
  }

  module ClassMethods
    def has_duration(*attributes)
      return has_duration '' if attributes.empty?

      attributes.each do |attribute|
        duration = duration_attribute_for attribute
        duration_in_seconds = "#{duration}_in_seconds"

        validates duration_in_seconds, numericality: { only_integer: true }

        define_method(duration) { seconds_to_string send(duration_in_seconds) }
        define_method("#{duration}=") { |v| send "#{duration_in_seconds}=", string_to_seconds(v) }
      end
    end

    protected

    def duration_attribute_for(attribute)
      attribute = '' if attribute.to_s == '_'
      "#{attribute}#{'_' if attribute.present?}duration"
    end
  end

  def seconds_to_string(duration)
    duration = duration.to_i.seconds.to_f
    string = []

    STRINGS
      .map do |unit, string|
        base = 1.send unit
        amount = ((duration - duration%base.to_f)/base.to_i).to_i

        if amount > 0
          duration -= amount.send(unit).seconds.to_i
          string.call amount
        end
      end
      .compact!
      .join ' '
  end

  def string_to_seconds(string)
    string = string.to_s
      .gsub(/[\s ]/, '')
      .sub(/\A(.*?#{FLOAT}h#{FLOAT})\z/, '\1m')
      .sub(/\A(.*?#{FLOAT}m#{FLOAT})\z/, '\1s')

    seconds = string.match(PATTERN)&.named_captures&.reduce(0) do |seconds, (unit, value)|
      seconds + value.send(unit.to_sym.in?([:years, :months]) ? :to_i : :to_f).send(unit).to_i
    end

    seconds.presence || 0
  end
end
