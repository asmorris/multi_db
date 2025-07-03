# frozen_string_literal: true

module UserDatabaseSwitching
  extend ActiveSupport::Concern

  included do
    before_action :switch_to_user_database, if: :logged_in?
  end

  private

  def switch_to_user_database
    return unless Current.account
    # Ensure user database exists
    UserDatabaseService.create_user_database(Current.account.id)

    # Switch to user database
    config = UserDatabaseService.user_database_config(Current.account.id)

    UserScopedRecord.establish_connection(config)
  end

  def restore_primary_database
    # Always restore primary connection after request
    UserScopedRecord.establish_connection(:primary) if defined?(UserScopedRecord)
  end

  def logged_in?
    Current.account.present?
  end
end
