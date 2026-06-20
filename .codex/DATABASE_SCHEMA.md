# DATABASE_SCHEMA.md

## Main Models

## User

Managed by Devise.

Suggested fields:

- id
- email
- encrypted_password
- name
- timezone
- role
- notification_preferences
- created_at
- updated_at

Associations:

```ruby
has_many :habits, dependent: :destroy
has_many :categories, dependent: :destroy
has_many :habit_completions, through: :habits
has_many :notifications, dependent: :destroy
has_many :activity_logs, dependent: :destroy
```

## Category

Represents user-defined habit grouping.

Fields:

- id
- user_id
- name
- color
- icon
- position
- created_at
- updated_at

Associations:

```ruby
belongs_to :user
has_many :habits, dependent: :nullify
```

Validations:

- name required
- name unique per user

Indexes:

- user_id
- [user_id, name]

## Habit

Represents a habit the user wants to track.

Fields:

- id
- user_id
- category_id
- name
- description
- color
- icon
- frequency
- days_of_week
- goal_count
- reminder_time
- active
- archived_at
- created_at
- updated_at

Associations:

```ruby
belongs_to :user
belongs_to :category, optional: true
has_many :habit_completions, dependent: :destroy
has_many :reminders, dependent: :destroy
```

Validations:

- name required
- frequency required
- goal_count greater than 0

Indexes:

- user_id
- category_id
- [user_id, active]
- [user_id, archived_at]

## HabitCompletion

Represents a completed habit on a specific date.

Fields:

- id
- habit_id
- completed_on
- note
- count
- created_at
- updated_at

Associations:

```ruby
belongs_to :habit
has_one :user, through: :habit
```

Validations:

- completed_on required
- completed_on unique per habit

Indexes:

- habit_id
- completed_on
- [habit_id, completed_on], unique

## Reminder

Represents reminder configuration for a habit.

Fields:

- id
- habit_id
- reminder_time
- days_of_week
- channel
- enabled
- created_at
- updated_at

Associations:

```ruby
belongs_to :habit
```

## Notification

Represents in-app notifications.

Fields:

- id
- user_id
- title
- body
- notification_type
- read_at
- created_at
- updated_at

Associations:

```ruby
belongs_to :user
```

## Achievement

Represents achievement definitions.

Fields:

- id
- name
- description
- key
- icon
- condition_type
- condition_value
- created_at
- updated_at

## UserAchievement

Represents achievements unlocked by users.

Fields:

- id
- user_id
- achievement_id
- unlocked_at
- created_at
- updated_at

Indexes:

- [user_id, achievement_id], unique

## ActivityLog

Represents user activity.

Fields:

- id
- user_id
- actor_id
- action
- subject_type
- subject_id
- metadata
- created_at

Indexes:

- user_id
- [subject_type, subject_id]
- created_at

## Initial MVP Tables

Build these first:

1. users
2. categories
3. habits
4. habit_completions

Add later:

1. reminders
2. notifications
3. achievements
4. user_achievements
5. activity_logs
