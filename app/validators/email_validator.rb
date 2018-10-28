class EmailValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    unless value =~ /\A[a-z0-9\.\-_]+@[a-z0-9\.\-_]+\.[a-z]{2,}\z/i
      record.errors.add attribute, options[:message] || :invalid
    end
  end
end
