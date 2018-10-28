# == Schema Information
#
# Table name: referentials
#
#  id                               :bigint(8)        not null, primary key
#  man_day_duration_in_seconds      :integer
#  work_per_day_duration_in_seconds :integer
#  mission_id                       :bigint(8)
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#

require 'test_helper'

class ReferentialTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
