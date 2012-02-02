class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :user_id
      t.string :name
      t.text :describe

      t.timestamps
    end
    add_column :ideas, :activity_id, :integer, :default => 1
  end
end
