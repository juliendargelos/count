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

class Referential < ApplicationRecord
  include Defaultable
  include Durationable

  DEFAULT_MAN_DAY_DURATION = '7h30'
  DEFAULT_WORK_PER_DAY_DURATION = '1h30'

  belongs_to :mission, optional: true
  has_duration :man_day
  has_duration :work_per_day
  has_default(
    man_day_duration_in_seconds: -> { default.man_day_duration_in_seconds },
    work_per_day_duration_in_seconds: -> { default.work_per_day_duration_in_seconds }
  )

  scope :settings, -> { where mission_id: nil }
  scope :default, -> { first || Referential.settings.first_or_create(man_day_duration: DEFAULT_MAN_DAY_DURATION, work_per_day_duration: DEFAULT_WORK_PER_DAY_DURATION) }

  def to_s
    name
  end

  def setting?
    mission.blank?
  end

  def default
    self.class.settings.default
  end

  def actual_duration_in_seconds of:
    return 0 if of.zero?
    (1.day.to_f/work_per_day_duration_in_seconds*of).to_i
  end

  def name
    "#{work_per_day_duration}/#{man_day_duration}"
  end
end
