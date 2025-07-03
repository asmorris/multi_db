# frozen_string_literal: true

require "sqlite3"
require "fileutils"

class UserDatabaseService
  class << self
    def create_user_database(account_id)
      database_path = user_database_path(account_id)

      # Create the database file if it doesn't exist
      unless File.exist?(database_path)
        # Ensure the storage directory exists
        FileUtils.mkdir_p(File.dirname(database_path))

        # Create connection to the new database
        connection = SQLite3::Database.new(database_path)
        connection.close

        # Run migrations on the new database
        migrate_user_database(account_id)

        Rails.logger.info "Created user database for account #{account_id}: #{database_path}"
      end

      database_path
    end

    def user_database_path(account_id)
      Rails.root.join("storage", "user_#{account_id}.sqlite3").to_s
    end

    def user_database_exists?(account_id)
      File.exist?(user_database_path(account_id))
    end

    def destroy_user_database(account_id)
      database_path = user_database_path(account_id)

      if File.exist?(database_path)
        File.delete(database_path)
        Rails.logger.info "Deleted user database for account #{account_id}: #{database_path}"
      end
    end

    def user_database_config(account_id)
      {
        adapter: "sqlite3",
        database: user_database_path(account_id),
        pool: ENV.fetch("RAILS_MAX_THREADS") { 5 },
        timeout: 5000
      }
    end

    def migrate_all_user_databases
      storage_dir = Rails.root.join("storage")
      user_dbs = Dir.glob(storage_dir.join("user_*.sqlite3"))

      user_dbs.each do |db_path|
        filename = File.basename(db_path)
        account_id = filename.match(/user_(\d+)\.sqlite3/)[1].to_i

        Rails.logger.info "Migrating user database for account #{account_id}"
        migrate_user_database(account_id)
      end

      Rails.logger.info "Finished migrating #{user_dbs.count} user databases"
    end

    private

    def migrate_user_database(account_id)
      # Get the user database configuration
      config = user_database_config(account_id)

      begin
        # Establish connection to user database
        ActiveRecord::Base.establish_connection(config)

        # Run all migrations on the user database
        # This will create schema_migrations table and run all pending migrations
        ActiveRecord::MigrationContext.new(
          Rails.application.config.paths["db/migrate"].first
        ).migrate

        Rails.logger.info "Migrated user database for account #{account_id}"
      ensure
        # Restore the original connection
        ActiveRecord::Base.establish_connection(:primary)
      end
    end
  end
end
