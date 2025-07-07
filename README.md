# GitLab Support Toolkit 🛠️

[![Ruby](https://img.shields.io/badge/ruby-3.2.0-red.svg)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/rails-7.0.0-red.svg)](https://rubyonrails.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](#testing)
[![GitLab Mirror](https://img.shields.io/badge/gitlab-mirror-orange.svg)](#)

A comprehensive Ruby on Rails application designed for GitLab support engineers to automate common troubleshooting tasks, analyze log files, and monitor GitLab instance health.

## Why This Exists

GitLab support engineers spend significant time manually analyzing log files, validating configurations, and testing API endpoints. This toolkit automates these repetitive tasks, providing a centralized web interface for GitLab troubleshooting workflows and reducing time-to-resolution for common support scenarios.

## Demo

[![asciicast](https://asciinema.org/a/demo-gitlab-support-toolkit.svg)](demo.cast)

*Rails application setup and log analysis workflow demonstration*

## Features

### 📊 **Dashboard & Analytics**
- Real-time overview of log analysis status
- Performance metrics and trending data
- Quick access to recent analyses and critical errors
- Statistical insights across all monitored instances

### 📄 **Log File Analysis**
- **Automated Pattern Detection**: Identifies common GitLab error patterns
- **Background Processing**: Large log files processed asynchronously with Sidekiq
- **File Upload Support**: Web interface for log file uploads via Active Storage
- **Analysis History**: Track and compare analyses over time
- **Export Results**: Generate reports for support tickets

### 🔧 **GitLab Configuration Validation**
- Configuration file syntax checking
- Best practice recommendations
- Security configuration audit
- Performance optimization suggestions

### 🌐 **API Endpoint Testing**
- Automated health checks for GitLab API endpoints
- Authentication testing and token validation
- Response time monitoring
- Comprehensive endpoint coverage

### 📈 **Performance Metrics Dashboard**
- Real-time GitLab instance monitoring
- Database performance tracking
- Background job queue analysis
- Resource utilization metrics

## Tech Stack

- **Backend**: Ruby 3.2.0 + Ruby on Rails 7.0
- **Database**: PostgreSQL with Active Record
- **Background Jobs**: Sidekiq for async processing
- **Frontend**: Bootstrap 5 + Stimulus + Importmap
- **File Storage**: Active Storage for log file uploads
- **API Integration**: GitLab REST API client
- **Testing**: RSpec test suite

## Prerequisites

- Ruby 3.2.0 or higher
- PostgreSQL 12+
- Redis (for Sidekiq)
- Node.js (for asset pipeline)
- GitLab instance with API access

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/daryllundy/gitlab-support-toolkit.git
cd gitlab-support-toolkit
```

### 2. Install Dependencies

```bash
# Install Ruby gems
bundle install

# Install JavaScript dependencies (if any)
# npm install  # Currently uses importmap, no npm needed
```

### 3. Database Setup

```bash
# Create and migrate database
rails db:create
rails db:migrate

# Seed with sample data (optional)
rails db:seed
```

### 4. Environment Configuration

Create a `.env` file with your configuration:

```env
# Database
DATABASE_URL=postgresql://user:password@localhost/gitlab_support_toolkit_development

# Redis (for Sidekiq)
REDIS_URL=redis://localhost:6379/0

# GitLab API Configuration
GITLAB_URL=https://your-gitlab-instance.com
GITLAB_API_TOKEN=glpat-xxxxxxxxxxxxxxxxxxxx

# Application
RAILS_ENV=development
SECRET_KEY_BASE=your-secret-key-here
```

### 5. Start Services

```bash
# Start Redis (if not running)
redis-server

# Start Sidekiq (in separate terminal)
bundle exec sidekiq

# Start Rails server
rails server
```

The application will be available at `http://localhost:3000`

## Usage

### Dashboard Overview

Visit the main dashboard to see:
- Recent log file uploads and analyses
- System statistics and health metrics
- Quick access to all major features
- Critical error alerts

### Log File Analysis

1. **Upload Log Files**:
   - Navigate to "Log Files" → "Upload New"
   - Select GitLab log files (application.log, production.log, etc.)
   - Add description and tags for organization

2. **Monitor Analysis Progress**:
   - View processing status in real-time
   - Background jobs handle large files automatically
   - Receive notifications when analysis completes

3. **Review Results**:
   - Browse detected error patterns
   - View recommended actions
   - Export findings for support tickets

### API Testing

1. **Configure GitLab Connection**:
   - Add GitLab instance URLs and API tokens
   - Test connectivity and permissions

2. **Run Automated Tests**:
   - Health check endpoints
   - Authentication validation
   - Performance benchmarks

3. **Monitor Results**:
   - View test history and trends
   - Set up alerts for failures
   - Generate uptime reports

## Development

### Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test files
bundle exec rspec spec/models/log_file_spec.rb
bundle exec rspec spec/controllers/

# Run tests with coverage
bundle exec rspec --format documentation
```

### Code Quality

```bash
# Ruby linting
bundle exec rubocop

# Auto-fix issues
bundle exec rubocop -a

# Security audit
bundle exec brakeman
```

### Database Management

```bash
# Create new migration
rails generate migration AddColumnToTable column:type

# Run pending migrations
rails db:migrate

# Rollback last migration
rails db:rollback

# Reset database (development only)
rails db:reset
```

### Background Jobs

```bash
# Monitor Sidekiq queues
bundle exec sidekiq

# Sidekiq web interface (visit /sidekiq)
# Available when server is running
```

## Project Structure

```
gitlab-support-toolkit/
├── app/
│   ├── controllers/           # Request handling
│   │   ├── dashboard_controller.rb
│   │   ├── log_files_controller.rb
│   │   ├── log_analyses_controller.rb
│   │   └── api_tests_controller.rb
│   ├── models/                # Business logic & database
│   │   ├── log_file.rb        # Log file management
│   │   ├── analysis.rb        # Analysis results
│   │   └── error_pattern.rb   # Error pattern detection
│   ├── jobs/                  # Background processing
│   │   └── log_analysis_job.rb
│   ├── services/              # External integrations
│   │   ├── gitlab_api_service.rb
│   │   └── log_parsing_service.rb
│   └── views/                 # UI templates
├── config/                    # Application configuration
├── db/                        # Database migrations & schema
├── spec/                      # Test suite
└── lib/                       # Custom libraries
```

## API Documentation

### Log File Endpoints

```bash
# Upload new log file
POST /log_files

# List all log files
GET /log_files

# View specific log file
GET /log_files/:id

# Start analysis
POST /log_files/:id/analyze
```

### Analysis Endpoints

```bash
# View analysis results
GET /analyses/:id

# Export analysis report
GET /analyses/:id/export
```

## Screenshots

### Dashboard Overview
*Main dashboard showing recent activity and system statistics*

### Log File Upload
*File upload interface with drag-and-drop support*

### Analysis Results
*Detailed analysis results with error categorization*

### API Testing Interface
*GitLab API endpoint testing and monitoring*

## Deployment

### Production Setup

1. **Environment Variables**:
   ```bash
   RAILS_ENV=production
   SECRET_KEY_BASE=your-production-secret
   DATABASE_URL=postgresql://...
   REDIS_URL=redis://...
   ```

2. **Asset Compilation**:
   ```bash
   rails assets:precompile
   ```

3. **Database Migration**:
   ```bash
   rails db:migrate RAILS_ENV=production
   ```

### Docker Deployment

```dockerfile
# Dockerfile included in repository
docker build -t gitlab-support-toolkit .
docker run -p 3000:3000 gitlab-support-toolkit
```

## Contributing

Contributions are welcome! Please follow these guidelines:

1. **Fork the repository** and create a feature branch
2. **Write tests** for new functionality
3. **Follow Rails conventions** and coding standards
4. **Update documentation** as needed
5. **Submit a pull request** with clear description

### Development Setup

```bash
# Clone your fork
git clone https://github.com/yourusername/gitlab-support-toolkit.git
cd gitlab-support-toolkit

# Create feature branch
git checkout -b feature/new-feature

# Make changes and test
bundle exec rspec

# Commit and push
git commit -m "Add new feature"
git push origin feature/new-feature
```

### Code Standards

- Follow Ruby style guide and Rails best practices
- Maintain test coverage above 80%
- Use semantic commit messages
- Update CHANGELOG.md for significant changes

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- **Issues**: [GitHub Issues](https://github.com/daryllundy/gitlab-support-toolkit/issues)
- **Documentation**: See `/docs` directory for detailed guides
- **Community**: [GitHub Discussions](https://github.com/daryllundy/gitlab-support-toolkit/discussions)

## Acknowledgments

- Built for the GitLab support engineering community
- Inspired by real-world GitLab troubleshooting workflows
- Uses GitLab API for comprehensive integration
- Special thanks to the Ruby on Rails and GitLab communities
