# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

GitLab Support Toolkit is a Ruby on Rails 7 application designed for GitLab support engineers to automate common troubleshooting tasks. The application provides log file analysis, GitLab configuration validation, performance metrics dashboards, and API endpoint testing capabilities.

## Tech Stack

- Ruby 3.2.0
- Rails 7.0.0
- PostgreSQL database
- Sidekiq for background job processing
- Bootstrap 5 for UI components
- GitLab API integration
- Redis for caching and job queuing

## Development Commands

### Setup
```bash
bundle install
rails db:create db:migrate
```

### Running the Application
```bash
rails server
```

### Database Management
```bash
rails db:migrate          # Run pending migrations
rails db:rollback         # Rollback last migration
rails db:seed             # Seed database with sample data
rails db:reset            # Drop, create, migrate, and seed database
```

### Testing
```bash
rspec                     # Run all tests
rspec spec/models/        # Run model tests
rspec spec/controllers/   # Run controller tests
rspec spec/path/to/file   # Run specific test file
```

### Console and Debugging
```bash
rails console             # Open Rails console
rails console --sandbox  # Open console in sandbox mode (rollback on exit)
```

### Code Quality
```bash
rubocop                   # Run Ruby linter
rubocop -a               # Auto-correct offenses
```

## Project Structure

This Rails application follows standard Rails conventions:
- `app/models/` - Business logic and database models
- `app/controllers/` - Request handling and API endpoints
- `app/views/` - UI templates and components
- `app/services/` - Business logic services for GitLab API integration
- `config/` - Application configuration and routes
- `db/` - Database migrations and schema
- `spec/` - RSpec test files

## Key Features Being Developed

1. **Log File Analysis** - Pattern matching and automated analysis of GitLab log files
2. **Configuration Validation** - Automated validation of GitLab configurations
3. **Performance Metrics** - Dashboard for GitLab performance monitoring
4. **API Testing** - Automated testing of GitLab API endpoints

## Development Notes

- The application integrates with GitLab's API for automation tasks
- Background jobs are processed using Sidekiq
- PostgreSQL is used for data persistence
- Bootstrap 5 provides responsive UI components
- The project is in early development stages with basic Rails structure established