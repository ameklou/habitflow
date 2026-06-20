# PROJECT_REQUIREMENTS.md

## Product Name

HabitFlow

## Product Vision

HabitFlow is a personal habit tracking application that helps users build consistency through daily habit tracking, streaks, reminders, statistics, and motivational feedback.

The product must be simple, fast, mobile-friendly, and easy to use every day.

The main goal is to help users answer three questions:

1. What habits should I complete today?
2. How consistent have I been?
3. What should I improve next?

## Target Users

### Guest Users

Can:

- Visit public landing page
- Register
- Log in
- Request password reset

### Standard Users

Can:

- Manage their profile
- Create habits
- Track habit completions
- View streaks
- View statistics
- Manage reminders
- Create categories
- Archive habits
- Delete their own data

### Admin Users

Can:

- View user list
- Disable abusive accounts
- View high-level app metrics
- Manage system settings

Admin functionality is not part of the first MVP unless explicitly requested.

## MVP Features

### Authentication

Users must be able to:

- Register
- Log in
- Log out
- Reset password
- Edit profile

Authentication should use Devise unless the project already has a different authentication system.

### Habit Management

Users can create, edit, archive, and delete habits.

Habit fields:

- Name
- Description
- Category
- Color
- Icon
- Frequency
- Goal count
- Reminder time
- Active status
- Archived status

### Habit Frequencies

Supported MVP frequencies:

- Daily
- Weekly
- Custom days of week

Future frequencies:

- Monthly
- Every X days
- Specific dates

### Habit Completion

Users can:

- Mark a habit complete for today
- Undo today's completion
- Add an optional note
- View completion history

Completion should be fast and possible from the dashboard.

Use Hotwire for one-click completion.

### Dashboard

The dashboard must show:

- Today's habits
- Completed habits
- Remaining habits
- Current streaks
- Weekly completion summary

### Streaks

The app must calculate:

- Current streak
- Longest streak
- Total completions
- Completion rate

### Categories

Users can create custom categories.

Default category ideas:

- Health
- Fitness
- Learning
- Career
- Finance
- Mindfulness
- Relationships

### Statistics

Users can view habit progress for:

- Last 7 days
- Last 30 days
- Last 90 days
- All time

Stats should include:

- Completion rate
- Total completions
- Missed days
- Best streak
- Current streak

## V1 Features

- Email reminders
- In-app notifications
- Achievement badges
- Activity feed
- Habit templates
- Dark mode
- Export data as CSV
- Weekly progress email

## V2 Features

- Accountability partner
- Shared habits
- Challenges
- Leaderboards
- Friend activity feed
- Team habit groups

## V3 AI Features

- AI habit coach
- Weekly AI habit report
- Personalized habit suggestions
- Streak risk prediction
- Motivation messages
- Behavior pattern analysis

## UX Requirements

The app must be:

- Mobile-first
- Fast
- Accessible
- Simple
- Minimalist
- Friendly and encouraging

Forms must:

- Use labels
- Show validation errors
- Preserve user input after failure
- Use clear buttons
- Avoid confusing flows

## Technical Requirements

Backend:

- Ruby on Rails
- PostgreSQL
- Redis where needed
- Sidekiq for background jobs

Frontend:

- Hotwire
- Turbo
- Stimulus
- Tailwind CSS

Testing:

- RSpec
- FactoryBot
- Capybara for system tests

Security:

- Devise for authentication
- Pundit for authorization
- Brakeman for security scanning

Deployment:

- Kamal
- Docker
- Hetzner VPS or similar VPS

## Non-Functional Requirements

The application must:

- Prevent unauthorized access to user data
- Avoid N+1 queries
- Use database indexes for common lookups
- Avoid unnecessary JavaScript
- Support responsive layouts
- Handle validation failures gracefully
- Use background jobs for slow tasks

## Definition of Done

A feature is complete when:

- It matches this requirements file
- It has model/controller/request/system tests where appropriate
- Authorization is handled
- Validation is handled
- UI works on mobile
- Hotwire behavior works without full page reload where appropriate
- Relevant tests pass
- Documentation is updated if needed
