class Project < ApplicationRecord
  belongs_to :company
  has_many :missions

  validates :name, presence: true
end
