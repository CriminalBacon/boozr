class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :store
      t.string :name
      t.string :price
      t.timestamps
    end
  end
end
