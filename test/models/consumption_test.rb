require "test_helper"

class ConsumptionTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  test "should belong to a user" do
    consumption = Consumption.build(user: @user, energy_type: :electricity, value: 100, unit: "kWh", measured_at: Time.current)
    assert consumption.valid?
    assert_equal @user, consumption.user
  end

  test "should validate presence of energy_type" do
    consumption = Consumption.build(user: @user, value: 100, unit: "kWh", measured_at: Time.current)
    assert_not consumption.valid?
    assert_includes consumption.errors[:energy_type], "can't be blank"
  end

  test "should validate presence of value" do
    consumption = Consumption.build(user: @user, energy_type: :electricity, unit: "kWh", measured_at: Time.current)
    assert_not consumption.valid?
    assert_includes consumption.errors[:value], "can't be blank"
  end

  test "should validate value is greater than or equal to 0" do
    consumption = Consumption.build(user: @user, energy_type: :electricity, value: -10, unit: "kWh", measured_at: Time.current)
    assert_not consumption.valid?
    assert_includes consumption.errors[:value], "must be greater than or equal to 0"
  end

  test "should validate presence of unit" do
    consumption = Consumption.build(user: @user, energy_type: :electricity, value: 100, measured_at: Time.current)
    assert_not consumption.valid?
    assert_includes consumption.errors[:unit], "can't be blank"
  end

  test "should validate presence of measured_at" do
    consumption = Consumption.build(user: @user, energy_type: :electricity, value: 100, unit: "kWh")
    assert_not consumption.valid?
    assert_includes consumption.errors[:measured_at], "can't be blank"
  end

  test "should define energy_type enum" do
    assert_equal 0, Consumption.energy_types[:electricity]
    assert_equal 1, Consumption.energy_types[:gas]
    assert_equal 2, Consumption.energy_types[:water]
  end

  test "should calculate average daily consumption" do
    user = User.create!(name: SecureRandom.hex(4), email: "test_user_#{SecureRandom.hex(4)}@example.com", password: "password", password_confirmation: "password")
    Consumption.create!(user: user, energy_type: :electricity, value: 100, unit: "kWh", measured_at: 3.days.ago)
    Consumption.create!(user: user, energy_type: :electricity, value: 150, unit: "kWh", measured_at: 2.days.ago)
    Consumption.create!(user: user, energy_type: :electricity, value: 200, unit: "kWh", measured_at: 1.day.ago)

    consumptions = user.consumptions.where(energy_type: :electricity)
    average = Consumption.average_daily_consumption(consumptions)

    assert_equal 150.0, average
  end

  test "should return 0 for average daily consumption if no consumptions" do
    user = User.create!(name: SecureRandom.hex(4), email: "test_user_#{SecureRandom.hex(4)}@example.com", password: "password", password_confirmation: "password")
    consumptions = user.consumptions.where(energy_type: :electricity)
    average = Consumption.average_daily_consumption(consumptions)
    assert_equal 0, average
  end

  test "should calculate average daily consumption for a single day" do
    user = User.create!(name: SecureRandom.hex(4), email: "test_user_#{SecureRandom.hex(4)}@example.com", password: "password", password_confirmation: "password")
    Consumption.create!(user: user, energy_type: :electricity, value: 100, unit: "kWh", measured_at: Time.current)

    consumptions = user.consumptions.where(energy_type: :electricity)
    average = Consumption.average_daily_consumption(consumptions)
    assert_equal 100.0, average
  end

  test "should calculate monthly total consumption" do
    user = User.create!(name: SecureRandom.hex(4), email: "test_user_#{SecureRandom.hex(4)}@example.com", password: "password", password_confirmation: "password")
    Consumption.create!(user: user, energy_type: :electricity, value: 50, unit: "kWh", measured_at: 2.months.ago.beginning_of_month + 5.days)
    Consumption.create!(user: user, energy_type: :electricity, value: 70, unit: "kWh", measured_at: 2.months.ago.beginning_of_month + 10.days)
    Consumption.create!(user: user, energy_type: :electricity, value: 100, unit: "kWh", measured_at: 1.month.ago.beginning_of_month + 1.day)
    Consumption.create!(user: user, energy_type: :electricity, value: 120, unit: "kWh", measured_at: 1.month.ago.beginning_of_month + 15.days)

    consumptions = user.consumptions.where(energy_type: :electricity)
    monthly_totals = Consumption.monthly_total_consumption(consumptions)

    expected_month_1 = (2.months.ago.beginning_of_month).strftime("%Y-%m")
    expected_month_2 = (1.month.ago.beginning_of_month).strftime("%Y-%m")

    assert_equal 120, monthly_totals[expected_month_1]
    assert_equal 220, monthly_totals[expected_month_2]
  end

  test "should return empty hash for monthly total consumption if no consumptions" do
    user = User.create!(name: SecureRandom.hex(4), email: "test_user_#{SecureRandom.hex(4)}@example.com", password: "password", password_confirmation: "password")
    consumptions = user.consumptions.where(energy_type: :electricity)
    monthly_totals = Consumption.monthly_total_consumption(consumptions)
    assert_equal ({}), monthly_totals
  end
end
