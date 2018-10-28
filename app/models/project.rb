# == Schema Information
#
# Table name: projects
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  notes      :text
#  company_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Project < ApplicationRecord
  belongs_to :company
  has_many :missions

  validates :name, presence: true

  def to_s
    name
  end
end
