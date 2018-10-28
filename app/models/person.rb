# == Schema Information
#
# Table name: people
#
#  id         :bigint(8)        not null, primary key
#  first_name :string
#  last_name  :string
#  email      :string
#  phone      :string
#  country    :string
#  city       :string
#  zipcode    :string
#  address    :string
#  company    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Person < ApplicationRecord
  include Defaultable
  include Phonable

  validates :email, email: true, allow_blank: true
  validates :phone, phone: true, allow_blank: true
  validates :zipcode, zipcode: true, allow_blank: true

  has_many :missions, foreign_key: :referent_id, dependent: :destroy
  has_default country: 'France', city: 'Paris'
  has_phone

  def to_s
    full_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
