class ZipcodeValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    unless value =~ /\A\d+\z/
      record.errors.add attribute, options[:message] || :invalid
    end
  end
end
