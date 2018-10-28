# == Schema Information
#
# Table name: tasks
#
#  id                          :bigint(8)        not null, primary key
#  name                        :string
#  difficulty                  :integer
#  minimum_duration_in_seconds :integer
#  maximum_duration_in_seconds :integer
#  mission_id                  :bigint(8)
#  pricing_id                  :bigint(8)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  position                    :integer
#

require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
