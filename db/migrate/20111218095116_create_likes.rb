class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :idea_id
      t.integer :score

      t.timestamps
    end
    add_index :likes, :user_id
    add_index :likes, :idea_id
    add_index :likes, [:user_id, :idea_id], :unique => true
  end
end
