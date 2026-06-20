# ARCHITECTURE.md

## Architecture Style

HabitFlow follows a conventional Ruby on Rails architecture with Hotwire-first frontend behavior.

The app should avoid unnecessary architectural complexity.

## Main Layers

### Models

Models own:

- Associations
- Validations
- Scopes
- Simple domain behavior

### Controllers

Controllers should:

- Authenticate users
- Authorize resources
- Load records
- Call services when needed
- Render responses

Controllers should not contain complex business logic.

### Views

Views should:

- Render HTML
- Use partials for repeated UI
- Use Turbo Frames and Turbo Streams when useful
- Avoid business logic

### Services

Use services for workflows involving:

- Multiple models
- Transactions
- External APIs
- Background jobs
- Complex calculations

Example services:

- `Habits::CompleteHabit`
- `Habits::UndoCompletion`
- `Habits::CalculateStats`
- `Reminders::SendHabitReminder`

### Policies

Use Pundit policies for authorization.

Every user-owned resource should have a policy.

### Jobs

Use background jobs for:

- Sending reminders
- Sending weekly reports
- Generating summaries
- Slow external calls

## Suggested Folder Structure

```text
app/models
app/controllers
app/views
app/services
app/policies
app/jobs
app/mailers
app/javascript/controllers
app/components or app/helpers
spec
```

## Hotwire Patterns

Use Turbo Frames for:

- Inline habit edit
- Dashboard habit cards
- Modal forms

Use Turbo Streams for:

- Marking habit complete
- Undoing completion
- Updating dashboard counters
- Appending activity feed items

Use Stimulus for:

- Dropdowns
- Modals
- Date picker behavior
- Small UI toggles

## Security Architecture

Every request that touches user data must:

1. Require authentication
2. Scope data to current user
3. Authorize the action
4. Validate input

Example:

```ruby
@habit = current_user.habits.find(params[:id])
authorize @habit
```

## Data Ownership

Most records belong to a user.

Records must not be queried globally unless they are public system records.

## Performance Notes

Avoid N+1 queries in:

- Dashboard
- Habit index
- Stats pages
- Activity feed

Use indexes for:

- Foreign keys
- Habit completion dates
- User dashboard queries
