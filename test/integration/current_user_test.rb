require "test_helper"

class CurrentUserTest < ActionDispatch::IntegrationTest
  def setup
    Current.reset
  end

  def teardown
    Current.reset
  end

  test "Current.account is nil when not logged in" do
    get "/"
    assert_nil Current.account
  end

  test "ApplicationController sets Current.account to nil for unauthenticated requests" do
    # Test that visiting a page without authentication clears Current.account
    get "/"

    # After the request, Current.account should be nil since no user is logged in
    assert_nil Current.account
  end
end
