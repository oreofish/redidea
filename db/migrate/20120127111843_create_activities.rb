class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :user_id
      t.string :name
      t.string :describe
      t.integer :owner_id

      t.timestamps
    end
    add_column :ideas, :activity_id, :integer, :default => 1
  end
end
