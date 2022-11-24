class CreatePricings < ActiveRecord::Migration[7.0]
  def change
    create_table :pricings do |t|
      t.string :title
      t.string :description
      t.string :price

      t.timestamps
    end
  end
end
