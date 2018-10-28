# == Schema Information
#
# Table name: companies
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  notes      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Company < ApplicationRecord
  has_many :people
  has_many :projects
  has_many :missions, through: :projects

  validates :name, presence: true

  def number_of_people
    people.count
  end

  def to_s
    name
  end
end
