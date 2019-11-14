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
#  invoice_number :integer          not null
#

class Mission < ApplicationRecord
  include Defaultable
  include Pricable
  include Durationable

  belongs_to :user
  belongs_to :referent, class_name: 'Person'
  belongs_to :project
  has_one :referential, dependent: :destroy
  has_one :company, through: :project
  has_many :pricings, dependent: :destroy
  has_many :taxes, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_price :_, :taxed
  has_duration :_, :actual, :rounded_actual
  has_default(
    uuid: -> { SecureRandom.uuid },
    referential: -> { Referential.settings.default },
    pricings: -> { Pricing.settings }
  )

  before_save :copy_referential, if: :referential_setting?
  before_validation :set_invoice_number, if: :invoice_number_blank?

  scope :chronological, -> (by: :beginning) { order "#{by}_date": :desc }
  scope :price_in_cents, -> { sum &:price_in_cents }
  scope :taxed_price_in_cents, -> { sum &:taxed_price_in_cents }
  scope :price, -> { Mission.price_in_cents_to_price price_in_cents }
  scope :taxed_price, -> { Mission.price_in_cents_to_price taxed_price_in_cents }
  scope :in_progress, -> { where ending_date: nil }
  scope :ended, -> (before: nil, after: nil) do
    ended = where.not ending_date: nil
    ended = ended.where 'ending_date <= ?', before unless before.nil?
    ended = ended.where 'ending_date >= ?', after unless after.nil?
    ended
  end
  default_scope { chronological }

  validates :name, presence: true
  validates :beginning_date, presence: true
  validates :uuid, presence: true, uniqueness: true
  validates :invoice_number, presence: true, uniqueness: true

  accepts_nested_attributes_for :referential
  accepts_nested_attributes_for :tasks

  def to_s
    name
  end

  alias_method :referential_id_base, :referential_id
  def referential_id
    referential_id_base.presence || Referential.settings.default.id
  end

  def pricings=(v)
    super v&.map { |pricing| pricing.setting? ? pricing.dup : pricing }
  end

  def taxes=(v)
    super v&.map { |tax| tax.setting? ? tax.dup : tax }
  end

  def duration_in_seconds
    tasks.sum &:duration_in_seconds
  end

  def actual_duration_in_seconds
    referential.actual_duration_in_seconds of: duration_in_seconds
  end

  def rounded_actual_duration_in_seconds
    actual_duration_in_seconds = self.actual_duration_in_seconds
    actual_duration_in_days = actual_duration_in_seconds.to_f/1.day.to_f
    return actual_duration_in_seconds if actual_duration_in_days <= 1

    rounded_actual_duration_in_seconds = actual_duration_in_days.round*1.day.to_i
    return actual_duration_in_seconds if rounded_actual_duration_in_seconds == actual_duration_in_seconds

    rounded_actual_duration_in_seconds + 1.day.to_i
  end

  def price_in_cents
    tasks.sum &:price_in_cents
  end

  def taxed_price_in_cents
    taxes.applied(on: price_in_cents).to_i
  end

  def estimated_ending_date
    beginning_date + actual_duration_in_seconds.seconds
  end

  def ended?
    ending_date.present?
  end

  protected

  def copy_referential
    self.referential = referential&.dup
  end

  def referential_setting?
    self.referential&.setting?
  end

  def invoice_number_blank?
    invoice_number.blank?
  end

  def set_invoice_number
    self.invoice_number = Mission.count + 1
  end
end
