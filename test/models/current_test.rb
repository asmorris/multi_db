require "test_helper"

class CurrentTest < ActiveSupport::TestCase
  def setup
    Current.reset
  end

  def teardown
    Current.reset
  end

  test "stores and retrieves account" do
    account = Account.new(email: "test@example.com")
    Current.account = account

    assert_equal account, Current.account
    assert_equal account, Current.user
  end

  test "user= sets account" do
    account = Account.new(email: "test@example.com")
    Current.user = account

    assert_equal account, Current.account
    assert_equal account, Current.user
  end

  test "starts with nil account" do
    assert_nil Current.account
    assert_nil Current.user
  end
end
