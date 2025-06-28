# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

- `bin/dev` - Start development server with Foreman (runs Rails server and Tailwind CSS watcher)
- `bin/rails server` - Start Rails server only
- `bin/rails console` - Open Rails console
- `bin/rails test` - Run test suite
- `bin/rubocop` - Run RuboCop linting
- `bin/brakeman` - Run security analysis
- `bin/kamal console` - SSH into deployed container and open Rails console
- `bin/kamal shell` - SSH into deployed container with bash shell

## Code Quality and Testing

- Tests use Rails default testing framework (not RSpec)
- Tests run in parallel by default
- Linting uses rubocop-rails-omakase configuration
- Security scanning with Brakeman is configured

## Architecture Overview

This is a Rails 8 application with the following key characteristics:

### Frontend Stack
- **Hotwire**: Uses Turbo and Stimulus for SPA-like behavior without complex JavaScript
- **Tailwind CSS**: Utility-first CSS framework for styling
- **Import Maps**: Modern JavaScript without bundling via importmap-rails
- **Modern Browser Support**: Only supports browsers with modern features (webp, web push, CSS nesting, etc.)

### Backend Stack
- **Rails 8.0.2**: Latest Rails with modern defaults
- **SQLite**: Database for all environments including production
- **Solid Queue**: Database-backed job processing (runs in Puma process by default)
- **Solid Cache**: Database-backed caching
- **Solid Cable**: Database-backed WebSocket connections

### Deployment
- **Kamal**: Zero-downtime deployment via Docker containers
- **Thruster**: HTTP asset caching and compression for production
- **Docker**: Containerized deployment ready

### Key Models
- `Fart` model with name and description attributes
- Standard Rails MVC structure with minimal customization

### Configuration Notes
- The application enforces modern browser compatibility in ApplicationController
- Uses frozen string literals in controllers
- Configured for deployment to single server initially but can scale to multiple servers
- SSL termination handled by Kamal proxy with Let's Encrypt

## Development Setup

1. Run `bin/setup` to install dependencies and setup database
2. Use `bin/dev` to start development server with all services
3. Run `bin/rails test` to execute test suite
4. Use `bin/rubocop` for code style checking

## Deployment

This application is configured for deployment using Kamal. Key deployment files:
- `config/deploy.yml` - Kamal deployment configuration
- `Dockerfile` - Container build instructions
- `.kamal/secrets` - Deployment secrets (not in repository)