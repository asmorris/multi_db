namespace :user_db do
  desc "List all user databases"
  task list: :environment do
    storage_dir = Rails.root.join("storage")
    user_dbs = Dir.glob(storage_dir.join("user_*.sqlite3"))

    if user_dbs.empty?
      puts "No user databases found."
    else
      puts "User databases:"
      user_dbs.each do |db_path|
        filename = File.basename(db_path)
        account_id = filename.match(/user_(\d+)\.sqlite3/)[1]
        size = File.size(db_path)
        puts "  Account #{account_id}: #{filename} (#{size} bytes)"
      end
    end
  end

  desc "Create database for a specific user account"
  task :create, [ :account_id ] => :environment do |t, args|
    account_id = args[:account_id]

    if account_id.blank?
      puts "Please provide an account ID: rake user_db:create[123]"
      exit 1
    end

    unless Account.exists?(account_id)
      puts "Account #{account_id} does not exist."
      exit 1
    end

    database_path = UserDatabaseService.create_user_database(account_id.to_i)
    puts "Created user database: #{database_path}"
  end

  desc "Delete database for a specific user account"
  task :destroy, [ :account_id ] => :environment do |t, args|
    account_id = args[:account_id]

    if account_id.blank?
      puts "Please provide an account ID: rake user_db:destroy[123]"
      exit 1
    end

    print "Are you sure you want to delete the database for account #{account_id}? [y/N]: "
    confirmation = STDIN.gets.chomp.downcase

    if confirmation == "y" || confirmation == "yes"
      UserDatabaseService.destroy_user_database(account_id.to_i)
      puts "Deleted user database for account #{account_id}"
    else
      puts "Operation cancelled."
    end
  end

  desc "Backup all user databases"
  task backup: :environment do
    backup_dir = Rails.root.join("tmp", "db_backups", Time.current.strftime("%Y%m%d_%H%M%S"))
    FileUtils.mkdir_p(backup_dir)

    storage_dir = Rails.root.join("storage")
    user_dbs = Dir.glob(storage_dir.join("user_*.sqlite3"))

    if user_dbs.empty?
      puts "No user databases to backup."
    else
      user_dbs.each do |db_path|
        filename = File.basename(db_path)
        backup_path = backup_dir.join(filename)
        FileUtils.cp(db_path, backup_path)
        puts "Backed up: #{filename}"
      end

      puts "Backup completed: #{backup_dir}"
    end
  end

  desc "Migrate all user databases with latest migrations"
  task migrate: :environment do
    puts "Migrating all user databases..."
    UserDatabaseService.migrate_all_user_databases
    puts "Migration completed!"
  end

  desc "Check database integrity for all user databases"
  task integrity_check: :environment do
    storage_dir = Rails.root.join("storage")
    user_dbs = Dir.glob(storage_dir.join("user_*.sqlite3"))

    if user_dbs.empty?
      puts "No user databases to check."
      return
    end

    user_dbs.each do |db_path|
      filename = File.basename(db_path)
      account_id = filename.match(/user_(\d+)\.sqlite3/)[1]

      begin
        db = SQLite3::Database.new(db_path)
        result = db.execute("PRAGMA integrity_check;").first.first

        if result == "ok"
          puts "✓ Account #{account_id}: #{filename} - OK"
        else
          puts "✗ Account #{account_id}: #{filename} - #{result}"
        end

        db.close
      rescue => e
        puts "✗ Account #{account_id}: #{filename} - Error: #{e.message}"
      end
    end
  end
end
