class CreateAchievements < ActiveRecord::Migration[8.1]
  def change
    create_table :achievements do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :key, null: false
      t.string :icon
      t.string :condition_type, null: false
      t.integer :condition_value, null: false, default: 1

      t.timestamps
    end

    add_index :achievements, :key, unique: true
    add_index :achievements, :condition_type
  end
end
