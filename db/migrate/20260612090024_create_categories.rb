class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :color
      t.string :icon
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :categories, [ :user_id, :name ], unique: true
    add_foreign_key :habits, :categories
  end
end
