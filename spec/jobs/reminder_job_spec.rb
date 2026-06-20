require "rails_helper"

RSpec.describe ReminderJob, type: :job do
  include ActiveJob::TestHelper

  around do |example|
    original_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :test
    clear_enqueued_jobs
    clear_performed_jobs
    example.run
  ensure
    clear_enqueued_jobs
    clear_performed_jobs
    ActiveJob::Base.queue_adapter = original_adapter
  end

  it "enqueues reminder emails that are due" do
    time = Time.zone.parse("2026-06-12 08:30")
    reminder = create(:reminder, reminder_time: "08:30", days_of_week: [ time.wday ])

    expect do
      described_class.perform_now(time)
    end.to have_enqueued_mail(ReminderMailer, :habit_reminder).with(reminder)
  end

  it "skips habits completed today" do
    time = Time.zone.parse("2026-06-12 08:30")
    reminder = create(:reminder, reminder_time: "08:30")
    create(:habit_completion, habit: reminder.habit, completed_on: time.to_date)

    expect do
      described_class.perform_now(time)
    end.not_to have_enqueued_mail(ReminderMailer, :habit_reminder)
  end
end
