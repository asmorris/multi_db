# Multi-Database SQLite Rails Application

A modern Rails 8 application demonstrating how to implement a multi-database setup with SQLite, where each user gets their own isolated database. This setup is perfect for SaaS applications requiring data isolation, multi-tenancy, or applications where each user needs their own data space.

## 🚀 Features

- **Multi-Database Architecture**: Each user gets their own SQLite database
- **Automatic Database Creation**: User databases are created on first login
- **Database Migration Management**: Easy migration of all user databases
- **Modern Rails 8 Stack**: Latest Rails with [Datastar](https://data-star.dev/guide/getting_started), Stimulus, and Tailwind CSS
- **Authentication**: Built-in user authentication with [Rodauth](https://rodauth.jeremyevans.net/rdoc/files/README_rdoc.html)
- **Database Tools**: Rake tasks for database management and maintenance
- **Production Ready**: Configured for deployment with Kamal and Docker

## 📋 Requirements

- Ruby 3.2+
- Rails 8.0+
- SQLite 3.8+
- Node.js (for asset compilation)

## 🛠️ Installation

1. **Clone the repository**

   ```bash
   git clone git@github.com:asmorris/multi_db.git
   cd data-star
   ```

2. **Install dependencies**

   ```bash
   bundle install
   ```

3. **Setup the database**

   ```bash
   bin/setup
   ```

4. **Start the development server**

   ```bash
   bin/dev
   ```

The application will be available at `http://localhost:3000`.

## 🏗️ Architecture Overview

### Multi-Database Setup

This application implements a unique multi-database architecture where:

- **Primary Database**: Stores user accounts and authentication data
- **User Databases**: Each user gets their own SQLite database for their data

### Key Components

#### 1. UserDatabaseService (`app/services/user_database_service.rb`)

Handles all database operations:

- Creates new user databases
- Manages database connections
- Runs migrations on user databases
- Provides utilities for database management

#### 2. UserDatabaseSwitching (`app/controllers/concerns/user_database_switching.rb`)

Controller concern that:

- Automatically switches to user's database on login
- Ensures user database exists before switching
- Maintains connection isolation

#### 3. UserScopedRecord (`app/models/user_scoped_record.rb`)

Base class for models that should be stored in user databases:

```ruby
class Post < UserScopedRecord
  # This model will be stored in the user's database
end
```

#### 4. Database Management Tasks (`lib/tasks/user_databases.rake`)

Rake tasks for managing user databases:

- List all user databases
- Create/destroy specific user databases
- Backup all user databases
- Migrate all user databases
- Check database integrity

## 🔧 Configuration

### Database Configuration

The application uses different database configurations:

- **Development**: `storage/development.sqlite3` (primary) + `storage/user_*.sqlite3` (user databases)
- **Test**: `storage/test.sqlite3` (primary) + test user databases
- **Production**: Multiple databases for different Rails subsystems (cache, queue, cable)

### Environment Variables

```bash
RAILS_MAX_THREADS=5    # Database connection pool size
SECRET_KEY_BASE=...    # Required for production
```

## 📊 Database Management

### User Database Operations

```bash
# List all user databases
rake user_db:list

# Create a database for a specific user
rake user_db:create[123]

# Delete a user's database (with confirmation)
rake user_db:destroy[123]

# Backup all user databases to local files
rake user_db:backup

# Migrate all user databases
rake user_db:migrate

# Check integrity of all user databases
rake user_db:integrity_check
```

### How It Works

1. **User Registration**: New users are created in the primary database
2. **First Login**: User database is automatically created using `UserDatabaseService`
3. **Data Isolation**: Each user's data is completely isolated in their own database
4. **Automatic Migration**: When new migrations are added, use `rake user_db:migrate` to update all user databases

## 🧪 Testing

Run the test suite:

```bash
bin/rails test
```

Run system tests:

```bash
bin/rails test:system
```

## 🔍 Code Quality

### Linting

```bash
bin/rubocop
```

### Security Analysis

```bash
bin/brakeman
```

## 🚀 Development

### Adding New User-Scoped Models

1. Create a new model inheriting from `UserScopedRecord`:

```ruby
class YourModel < UserScopedRecord
  # Your model logic
end
```

2. Create a migration:

```bash
bin/rails generate migration CreateYourModels
```

3. Migrate all user databases:

```bash
rake user_db:migrate
```

### Development Commands

- `bin/dev` - Start development server with Foreman (Rails server + Tailwind CSS watcher)
- `bin/rails server` - Start Rails server only
- `bin/rails console` - Open Rails console
- `bin/rails test` - Run test suite

## 📦 Deployment

This application is configured for deployment using Kamal:

1. **Configure deployment settings** in `config/deploy.yml`
2. **Set up secrets** in `.kamal/secrets`
3. **Deploy**:

   ```bash
   kamal deploy
   ```

### Production Database Management

In production, you can manage user databases using:

```bash
# SSH into the container and run rake tasks
bin/kamal console
rake user_db:list
```

## 🛡️ Security Considerations

- Each user's data is completely isolated in separate databases
- Database switching is handled automatically on authentication
- User database paths are validated and sanitized
- No cross-user data leakage is possible with this architecture

## 🔧 Tech Stack

- **Backend**: Rails 8.0.2, Ruby 3.2+
- **Database**: SQLite 3.8+
- **Authentication**: Rodauth
- **Frontend**: Datastar, Tailwind CSS
- **Background Jobs**: Solid Queue
- **Caching**: Solid Cache
- **WebSockets**: Solid Cable
- **Deployment**: Kamal, Docker
- **Testing**: Rails default testing framework

## 📈 Scaling Considerations

This architecture may be suitable for:

- **Small to Medium SaaS applications** (up to thousands of users)
- **Applications requiring strict data isolation**
- **Rapid prototyping and development**
- **Single-server deployments**

For larger scale applications, consider:

- Using PostgreSQL with schema-based multi-tenancy
- Implementing database sharding
- Using separate database servers

**Please note that I have not tested this architecture on a large scale, so it may not be suitable for production use. I just wanted to try out [a database for each user](https://www.youtube.com/watch?v=AtZiAU9-A5A) with rails**

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is open source and available under the [MIT License](https://opensource.org/license/MIT).

## 🙏 Acknowledgments

- Rails team for the excellent framework
- SQLite team for the reliable database engine
- Datastar team for the alternative frontend approach
- Rodauth for the authentication solution
- Anthropic team for Claude helping me write this README

If you've made it this far, I hope you have a wonderful day!

