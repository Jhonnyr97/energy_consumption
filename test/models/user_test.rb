require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  test "should have many consumptions" do
    assert_respond_to @user, :consumptions
    assert_instance_of Consumption, @user.consumptions.build
  end

  test "should destroy associated consumptions when user is destroyed" do
    consumption_count = @user.consumptions.count
    assert_difference('Consumption.count', -consumption_count) do
      @user.destroy
    end
  end

  test "name should be present" do
    @user.name = nil
    assert_not @user.valid?
    @user.name = "Test User"
    assert @user.valid?
  end
end
