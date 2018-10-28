class PhoneValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    unless value.gsub(/[\s ]/, '') =~ /\A(?:0|\+(?:\d-)?[\d]{1,3})\d{9}\z/
      record.errors.add attribute, options[:message] || :invalid
    end
  end
end
