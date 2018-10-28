# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  first_name      :string           default(""), not null
#  last_name       :string           default(""), not null
#  email           :string           default(""), not null
#  password_digest :string           default(""), not null
#  phone           :string           default(""), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  include Phonable

  validates :email, presence: true, email: true, uniqueness: true
  validates :phone, phone: true, allow_blank: true
  validates :password, presence: true, length: { minimum: 6 }, allow_blank: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_secure_password
  has_phone

  def full_name
    "#{first_name} #{last_name}"
  end

  def to_s
    first_name
  end
end
