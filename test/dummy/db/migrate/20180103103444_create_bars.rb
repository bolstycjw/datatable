class CreateBars < ActiveRecord::Migration[5.2]
  def change
    create_table :bars do |t|
      t.references :foo, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
