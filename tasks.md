Phase 1:
- [x] Generate Rails app: `rails new . --database=postgresql --skip-test`
- [x] Setup basic structure
- [x] Push initial Rails commit
- [x] Setup database: `rails db:create db:migrate`
- [x] Add gems: Devise, Bootstrap, Sidekiq
Phase 2:
- [x] Generate models:
  - [x] `rails g model LogFile`
  - [x] `rails g model Analysis`
  - [x] `rails g model ErrorPattern`
- [x] Create controllers:
  - [x] `rails g controller Dashboard`
  - [x] `rails g controller LogAnalyses`
  - [x] `rails g controller ApiTests`
Phase 3:
- [x] Implement core features:
  - [x] File upload with Active Storage
  - [x] Log parsing service
  - [x] GitLab API integration
  - [x] Basic UI with Bootstrap
