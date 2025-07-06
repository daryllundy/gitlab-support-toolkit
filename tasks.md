Phase 1:
- [x] Generate Rails app: `rails new . --database=postgresql --skip-test`
- [ ] Setup basic structure
- [ ] Push initial Rails commit
- [ ] Setup database: `rails db:create db:migrate`
- [ ] Add gems: Devise, Bootstrap, Sidekiq
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