# == Schema Information
#
# Table name: clients
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

require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
