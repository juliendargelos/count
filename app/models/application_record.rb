class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def has_one(relation, *args)
      super relation, *args

      define_method("#{relation}_id") { send(relation)&.id }
      define_method("#{relation}_id=") do |v|
        send "#{relation}=", self.class.reflections[relation.to_s].klass.find_by(id: v)
      end
    end
  end

  def as_json(options = nil)
    options = {} unless options.is_a? Hash
    options = options.symbolize_keys
    unless options[:methods].is_a? Array
      options[:methods] = options[:methods].present? ? [options[:methods]] : []
    end

    options[:methods] << :to_s

    super(options)
  end
end
