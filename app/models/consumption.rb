class Consumption < ApplicationRecord
  belongs_to :user

  validates :energy_type, presence: true
  validates :value, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :unit, presence: true
  validates :measured_at, presence: true

  enum :energy_type, { electricity: 0, gas: 1, water: 2 }


  def self.ransackable_attributes(auth_object = nil)
    %w[energy_type measured_at]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  def self.average_daily_consumption(consumptions)
    total_consumption = consumptions.sum(:value)

    first_consumption_date = consumptions.minimum(:measured_at)&.to_date
    last_consumption_date = consumptions.maximum(:measured_at)&.to_date

    if first_consumption_date && last_consumption_date
      number_of_days = (last_consumption_date - first_consumption_date).to_i + 1
    else
      number_of_days = 0
    end

    number_of_days > 0 ? (total_consumption / number_of_days.to_f) : 0
  end

  def self.monthly_peak_consumption(scope)
    scope.group(Arel.sql("strftime('%Y-%m', measured_at)")).maximum(:value)
  end

  def self.monthly_total_consumption(scope)
    scope.group(Arel.sql("strftime('%Y-%m', measured_at)")).sum(:value)
  end

  def self.energy_options
    energy_types.keys.map { |type| [type.humanize, energy_types[type]] }
  end
end
