# == Schema Information
#
# Table name: missions
#
#  id             :bigint(8)        not null, primary key
#  uuid           :string           not null
#  name           :string
#  beginning_date :date
#  ending_date    :date
#  user_id        :bigint(8)
#  referent_id    :bigint(8)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  notes          :text
#  project_id     :bigint(8)
#  invoice_number :integer
#

require 'test_helper'

class MissionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
