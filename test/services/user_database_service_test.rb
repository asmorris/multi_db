require "minitest/autorun"
require_relative "../../config/environment"

class UserDatabaseServiceTest < Minitest::Test
  def setup
    @account_id = 999
    @test_database_path = Rails.root.join("storage", "user_#{@account_id}.sqlite3")

    # Clean up any existing test database
    File.delete(@test_database_path) if File.exist?(@test_database_path)
  end

  def teardown
    # Clean up test database
    File.delete(@test_database_path) if File.exist?(@test_database_path)
  end

  def test_creates_user_database_file
    refute UserDatabaseService.user_database_exists?(@account_id)

    database_path = UserDatabaseService.create_user_database(@account_id)

    assert File.exist?(database_path)
    assert UserDatabaseService.user_database_exists?(@account_id)
    assert_equal @test_database_path.to_s, database_path
  end

  def test_returns_existing_database_path_if_already_exists
    # Create database first time
    first_path = UserDatabaseService.create_user_database(@account_id)

    # Call again - should return same path without error
    second_path = UserDatabaseService.create_user_database(@account_id)

    assert_equal first_path, second_path
    assert File.exist?(first_path)
  end

  def test_generates_correct_database_path
    expected_path = Rails.root.join("storage", "user_#{@account_id}.sqlite3").to_s
    actual_path = UserDatabaseService.user_database_path(@account_id)

    assert_equal expected_path, actual_path
  end

  def test_destroys_user_database
    # Create database first
    UserDatabaseService.create_user_database(@account_id)
    assert File.exist?(@test_database_path)

    # Destroy database
    UserDatabaseService.destroy_user_database(@account_id)
    refute File.exist?(@test_database_path)
    refute UserDatabaseService.user_database_exists?(@account_id)
  end

  def test_destroying_non_existent_database_does_not_raise_error
    refute File.exist?(@test_database_path)

    # Should not raise an error
    UserDatabaseService.destroy_user_database(@account_id)

    # Test passes if no exception is raised
    assert true
  end

  def test_user_database_config_returns_correct_settings
    config = UserDatabaseService.user_database_config(@account_id)

    assert_equal "sqlite3", config[:adapter]
    assert_equal @test_database_path.to_s, config[:database]
    assert config[:pool].present?
    assert config[:timeout].present?
  end
end
