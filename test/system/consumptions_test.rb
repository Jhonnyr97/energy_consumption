require "application_system_test_case"

class ConsumptionsTest < ApplicationSystemTestCase
  setup do
    @consumption = consumptions(:one)
  end

  test "visiting the index" do
    visit consumptions_url
    assert_selector "h1", text: "Consumptions"
  end

  test "should create consumption" do
    visit consumptions_url
    click_on "New consumption"

    fill_in "Energy type", with: @consumption.energy_type
    fill_in "Measured at", with: @consumption.measured_at
    fill_in "Unit", with: @consumption.unit
    fill_in "Value", with: @consumption.value
    click_on "Create Consumption"

    assert_text "Consumption was successfully created"
    click_on "Back"
  end

  test "should update Consumption" do
    visit consumption_url(@consumption)
    click_on "Edit this consumption", match: :first

    fill_in "Energy type", with: @consumption.energy_type
    fill_in "Measured at", with: @consumption.measured_at.to_s
    fill_in "Unit", with: @consumption.unit
    fill_in "Value", with: @consumption.value
    click_on "Update Consumption"

    assert_text "Consumption was successfully updated"
    click_on "Back"
  end

  test "should destroy Consumption" do
    visit consumption_url(@consumption)
    accept_confirm { click_on "Destroy this consumption", match: :first }

    assert_text "Consumption was successfully destroyed"
  end
end
