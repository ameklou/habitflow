class CreateReminders < ActiveRecord::Migration[8.1]
  def change
    create_table :reminders do |t|
      t.references :habit, null: false, foreign_key: true
      t.time :reminder_time, null: false
      t.integer :days_of_week, array: true, default: [], null: false
      t.string :channel, null: false, default: "email"
      t.boolean :enabled, null: false, default: true

      t.timestamps
    end

    add_index :reminders, [ :habit_id, :enabled ]
    add_index :reminders, :reminder_time
  end
end
