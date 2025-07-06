Phase 1:
- [x] Generate Rails app: `rails new . --database=postgresql --skip-test`
- [x] Setup basic structure
- [x] Push initial Rails commit
- [x] Setup database: `rails db:create db:migrate`
- [x] Add gems: Devise, Bootstrap, Sidekiq
Phase 2:
- [ ] Generate models:
  - [ ] `rails g model LogFile`
  - [ ] `rails g model Analysis`
  - [ ] `rails g model ErrorPattern`
- [ ] Create controllers:
  - [ ] `rails g controller Dashboard`
  - [ ] `rails g controller LogAnalyses`
  - [ ] `rails g controller ApiTests`
Phase 3:
- [ ] Implement core features:
  - [ ] File upload with Active Storage
  - [ ] Log parsing service
  - [ ] GitLab API integration
  - [ ] Basic UI with Bootstrap
