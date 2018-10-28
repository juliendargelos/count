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

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
