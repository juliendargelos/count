module Pricable
  extend ActiveSupport::Concern

  DEVISE = '€'

  module ClassMethods
    def has_price(*attributes)
      return has_price '' if attributes.empty?

      attributes.each do |attribute|
        price = price_attribute_for attribute
        price_in_cents = "#{price}_in_cents"

        validates price_in_cents, numericality: { only_integer: true }

        define_method(price) { self.class.price_in_cents_to_price send(price_in_cents) }
        define_method("#{price}=") { |v| send "#{price_in_cents}=", self.class.price_to_price_in_cents(v) }
      end
    end

    def price_in_cents_to_price(price_in_cents)
      "#{'%.2f' % (price_in_cents.to_f/100)}#{DEVISE}"
    end

    def price_to_price_in_cents(price)
      (price.to_f*100).to_i
    end

    protected

    def price_attribute_for(attribute)
      attribute = '' if attribute.to_s == '_'
      "#{attribute}#{'_' if attribute.present?}price"
    end
  end
end
