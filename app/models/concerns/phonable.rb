module Phonable
  extend ActiveSupport::Concern

  DEFAULT_CODE = 33

  included do
    before_validation :clean_phone
  end

  module ClassMethods
    def has_phone(attribute = :phone)
      (phone_attributes << attribute.to_s.to_sym).uniq!
      define_method attribute do |pretty: true|
        if pretty
          super().to_s
            .sub(/\A\+#{DEFAULT_CODE}\s*(\d+)/, '0\1')
            .gsub(/\A(.+)(\d{2})(\d{2})(\d{2})(\d{2})\z/, '\1 \2 \3 \4 \5')
        else
          super()
        end
      end
    end

    def phone_attributes
      @phone_attributes ||= []
    end
  end

  protected

  def clean_phone
    self.class.phone_attributes.each do |attribute|
      value = send(attribute).to_s
        .gsub(/\s/, '')
        .gsub(/\A0/, "+#{DEFAULT_CODE} ")

      send "#{attribute}=", value
    end
  end
end
