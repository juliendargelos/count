# == Schema Information
#
# Table name: taxes
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  weight     :float
#  mission_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tax < ApplicationRecord
  include Defaultable
  include Pricable

  belongs_to :mission, optional: true
  has_default name: -> { "Tax ##{(mission.present? ? mission.taxes.count : self.class.count) + 1}" }

  validates :name, presence: true
  validates :weight, presence: true, numericality: true

  scope :settings, -> { where mission: nil }
  scope :applied, -> (on:) { on.to_f + sum(&on.to_f.method(:*)) }

  delegate :+, to: :weight
  delegate :-, to: :weight
  delegate :*, to: :weight
  delegate :/, to: :weight

  has_price

  def to_s
    name
  end

  def percentage
    "#{(weight || 0)*100}%"
  end

  def percentage=(v)
    self.weight = v.to_f/100
  end

  def setting?
    mission.blank?
  end

  def coerce(other)
   [other.to_f, weight]
  end

  def price_in_cents
    (mission.price_in_cents.to_f * self).to_i
  end
end
