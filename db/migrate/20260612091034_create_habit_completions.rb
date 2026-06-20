class CreateHabitCompletions < ActiveRecord::Migration[8.1]
  def change
    create_table :habit_completions do |t|
      t.references :habit, null: false, foreign_key: true
      t.date :completed_on, null: false
      t.text :note
      t.integer :count, null: false, default: 1

      t.timestamps
    end

    add_index :habit_completions, :completed_on
    add_index :habit_completions, [ :habit_id, :completed_on ], unique: true
  end
end
