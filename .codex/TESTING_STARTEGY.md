# TESTING_STRATEGY.md

## Testing Framework

Use RSpec unless the project already uses Minitest.

Recommended gems:

- rspec-rails
- factory_bot_rails
- capybara
- shoulda-matchers

Do not add gems without approval if the project already has testing tools.

## Test Types

## Model Specs

Test:

- Validations
- Associations
- Scopes
- Domain methods
- Streak calculations
- Completion rules

Examples:

- Habit requires a name
- Habit belongs to user
- HabitCompletion is unique per habit and date
- Current streak calculation is correct

## Request Specs

Test:

- Authentication required
- Authorization rules
- CRUD success
- CRUD failure
- Invalid input handling
- User cannot access another user's records

## System Specs

Test important user flows:

- User signs up
- User creates a habit
- User marks habit complete
- User sees dashboard update
- User edits habit
- User archives habit

## Service Specs

Test business workflows:

- Complete habit
- Undo completion
- Calculate stats
- Send reminder
- Unlock achievement

## Policy Specs

Test authorization:

- User can manage own habits
- User cannot manage another user's habits
- Admin can access admin resources

## Required Test Commands

Run focused tests first:

```bash
bundle exec rspec spec/models/habit_spec.rb
bundle exec rspec spec/requests/habits_spec.rb
bundle exec rspec spec/system/habit_tracking_spec.rb
```

Run all tests before major completion:

```bash
bundle exec rspec
```

Run security and style checks:

```bash
bundle exec rubocop
bundle exec brakeman
```

## Testing Rules for Codex

Codex must:

- Add tests for meaningful behavior changes
- Run relevant tests when possible
- Report exact commands run
- Report failures honestly
- Never claim tests passed if not run
