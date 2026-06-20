class CreateHabits < ActiveRecord::Migration[8.1]
  def change
    create_table :habits do |t|
      t.references :user, null: false, foreign_key: true
      t.bigint :category_id
      t.string :name, null: false
      t.text :description
      t.string :color
      t.string :icon
      t.string :frequency, null: false, default: "daily"
      t.integer :days_of_week, array: true, default: [], null: false
      t.integer :goal_count, null: false, default: 1
      t.time :reminder_time
      t.boolean :active, null: false, default: true
      t.datetime :archived_at

      t.timestamps
    end

    add_index :habits, :category_id
    add_index :habits, [ :user_id, :active ]
    add_index :habits, [ :user_id, :archived_at ]
  end
end
