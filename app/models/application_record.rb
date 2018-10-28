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
end
