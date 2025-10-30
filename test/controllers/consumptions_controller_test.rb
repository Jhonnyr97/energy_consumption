require "test_helper"

class ConsumptionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    sign_in @user
    @consumption = consumptions(:one)
  end

  test "should get index" do
    get consumptions_url
    assert_response :success
  end

  test "should get index as json with aggregated data" do
    get consumptions_url(format: :json)
    assert_response :success
    json_response = JSON.parse(response.body)

    assert_kind_of Hash, json_response["monthly_peak_consumption"]
    assert_kind_of Hash, json_response["monthly_total_consumption"]
  end

  test "should get new" do
    get new_consumption_url
    assert_response :success
  end

  test "should create consumption" do
    assert_difference("Consumption.count") do
      post consumptions_url, params: { consumption: { energy_type: @consumption.energy_type, measured_at: @consumption.measured_at, unit: @consumption.unit, value: @consumption.value } }
    end

    assert_redirected_to consumption_url(Consumption.last)
  end

  test "should show consumption" do
    get consumption_url(@consumption)
    assert_response :success
  end

  test "should get edit" do
    get edit_consumption_url(@consumption)
    assert_response :success
  end

  test "should update consumption" do
    patch consumption_url(@consumption), params: { consumption: { energy_type: @consumption.energy_type, measured_at: @consumption.measured_at, unit: @consumption.unit, value: @consumption.value } }
    assert_redirected_to consumption_url(@consumption)
  end

  test "should destroy consumption" do
    assert_difference("Consumption.count", -1) do
      delete consumption_url(@consumption)
    end

    assert_redirected_to consumptions_url
  end
end
