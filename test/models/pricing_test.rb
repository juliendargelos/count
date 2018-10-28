# == Schema Information
#
# Table name: pricings
#
#  id                     :bigint(8)        not null, primary key
#  name                   :string
#  man_day_price_in_cents :integer
#  mission_id             :bigint(8)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'test_helper'

class PricingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
