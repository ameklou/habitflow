# ROADMAP.md

## Phase 0: Project Foundation

Goal: Set up a clean Rails foundation.

Tasks:

- Configure RSpec
- Configure FactoryBot
- Configure RuboCop
- Configure Brakeman
- Add Devise
- Add Pundit
- Add base layout
- Add flash messages
- Add authentication pages

Definition of done:

- App boots locally
- Tests run
- User can register, log in, and log out

## Phase 1: Habit MVP

Goal: Users can manage and complete habits.

Tasks:

- Add Habit model
- Add Category model
- Add HabitCompletion model
- Add habit CRUD
- Add category CRUD
- Add dashboard
- Add one-click completion
- Add undo completion
- Add basic streak calculation

Definition of done:

- User can create habits
- User can complete habits for today
- User can see today's progress
- User data is private

## Phase 2: Progress and Statistics

Goal: Users understand their consistency.

Tasks:

- Add stats page
- Add current streak
- Add longest streak
- Add completion rate
- Add weekly summary
- Add monthly summary
- Add progress charts or simple visual indicators

Definition of done:

- User can see habit performance over time

## Phase 3: Reminders and Notifications

Goal: Help users remember habits.

Tasks:

- Add reminder settings
- Add reminder jobs
- Add email reminders
- Add in-app notifications
- Add notification preferences

Definition of done:

- Users can receive reminders for habits

## Phase 4: Motivation Features

Goal: Increase engagement.

Tasks:

- Add achievements
- Add activity feed
- Add habit templates
- Add weekly progress email
- Add celebration UI for milestones

Definition of done:

- Users receive motivational feedback

## Phase 5: Production Hardening

Goal: Prepare for real users.

Tasks:

- Add pagination
- Add database indexes
- Add security scans
- Add error pages
- Add monitoring hooks
- Add backup strategy
- Add deployment docs

Definition of done:

- App is deployable and maintainable
