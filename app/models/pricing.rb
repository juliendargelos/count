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

class Pricing < ApplicationRecord
  include Defaultable
  include Pricable

  DEFAULT_NAME = 'Default'
  DEFAULT_MAN_DAY_PRICE = '290€'

  validates :name, presence: true

  belongs_to :mission, optional: true
  has_many :tasks, dependent: :destroy
  has_price :man_day, :taxed_man_day
  has_default(
    name: -> { "Pricing ##{(mission.present? ? mission.pricings.count : self.class.count) + 1}" },
    man_day_price_in_cents: -> { default.man_day_price_in_cents }
  )

  scope :settings, -> { where mission: nil }
  scope :used, -> { joins(:tasks).distinct }
  scope :default, -> { first || Pricing.settings.first_or_create(name: DEFAULT_NAME, man_day_price: DEFAULT_MAN_DAY_PRICE) }

  def to_s
    name
  end

  def setting?
    mission.blank?
  end

  def used?
    return false if setting?
    mission.tasks.pluck(:pricing_id).include? id
  end

  def default
    setting? ? self.class.settings.default : mission.pricings.default
  end

  def taxed_man_day_price_in_cents
    mission&.taxes&.applied(on: man_day_price_in_cents).to_i
  end
end
