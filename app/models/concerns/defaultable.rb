module Defaultable
  extend ActiveSupport::Concern

  included do
    after_initialize :set_default
  end

  module ClassMethods
    def has_default(attributes = nil)
      default_values.merge! attributes if attributes.is_a? Hash
    end

    def default_values
      @default_values ||= {}
    end
  end

  protected

  def set_default
    self.class.default_values.each do |attribute, value|
      next if send(attribute).present?
      value = instance_exec(&value) if value.is_a? Proc

      send "#{attribute}=", value
    end
  end
end
