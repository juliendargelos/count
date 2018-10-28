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

class Task < ApplicationRecord
  include Defaultable
  include Durationable
  include Pricable

  MINIMUM_DIFFICULTY = 0
  MAXIMUM_DIFFICULTY = 10

  belongs_to :mission
  belongs_to :pricing
  has_price :_, :taxed, :minimum, :taxed_minimum, :maximum, :taxed_maximum
  has_duration :_, :minimum, :maximum
  has_default(
    name: -> { "Task ##{mission.tasks.count + 1}" },
    difficulty: ((MAXIMUM_DIFFICULTY - MINIMUM_DIFFICULTY)/2).to_i,
    pricing: -> { mission.pricings.default },
    position: -> { (mission.tasks.pluck(:position).last || 0) + 1 },
    minimum_duration: '2h',
    maximum_duration: '4h'
  )

  validates :difficulty, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: MINIMUM_DIFFICULTY, less_than_or_equal_to: MAXIMUM_DIFFICULTY }
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, uniqueness: { scope: :mission_id }

  scope :null, -> { new difficulty: 0, minimum_duration: 0, maximum_duration: 0 }
  default_scope { order position: :asc }

  def difficulty_factor
    (difficulty.to_f - MINIMUM_DIFFICULTY.to_f)/(MAXIMUM_DIFFICULTY.to_f - MINIMUM_DIFFICULTY.to_f)
  end

  def duration_in_seconds
    (minimum_duration_in_seconds.to_f + difficulty_factor*(maximum_duration_in_seconds - minimum_duration_in_seconds).to_f).to_i
  end

  def minimum_price_in_cents
    (minimum_duration_in_seconds.to_f/mission.referential.man_day_duration_in_seconds.to_f*pricing.man_day_price_in_cents.to_f).to_i
  end

  def taxed_minimum_price_in_cents
    mission.taxes.applied(on: minimum_price_in_cents).to_i
  end

  def maximum_price_in_cents
    (maximum_duration_in_seconds.to_f/mission.referential.man_day_duration_in_seconds.to_f*pricing.man_day_price_in_cents.to_f).to_i
  end

  def taxed_maximum_price_in_cents
    mission.taxes.applied(on: maximum_price_in_cents).to_i
  end

  def price_in_cents
    man_day_duration_in_seconds = mission.referential.man_day_duration_in_seconds.to_f
    man_day_price_in_cents = pricing.man_day_price_in_cents.to_f
    return 0 if man_day_duration_in_seconds == 0 || man_day_price_in_cents == 0
    (duration_in_seconds.to_f/man_day_duration_in_seconds*man_day_price_in_cents).to_i
  end

  def taxed_price_in_cents
    mission.taxes.applied(on: price_in_cents).to_i
  end

  def to_s
    name
  end
end
