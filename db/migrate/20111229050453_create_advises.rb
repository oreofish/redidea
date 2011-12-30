class CreateAdvises < ActiveRecord::Migration
  def change
    create_table :advises do |t|
      t.string :content

      t.timestamps
    end
  end
end
