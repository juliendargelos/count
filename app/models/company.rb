class Company < ApplicationRecord
  has_many :people
  has_many :projects
  has_many :missions, through: :projects

  validates :name, presence: true

  def number_of_people
    people.count
  end
end
