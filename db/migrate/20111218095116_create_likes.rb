class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :idea_id
      t.integer :score

      t.timestamps
    end
  end
end
