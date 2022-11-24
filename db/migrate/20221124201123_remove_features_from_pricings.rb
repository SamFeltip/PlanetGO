class RemoveFeaturesFromPricings < ActiveRecord::Migration[7.0]
  def change
    remove_column :pricings, :description, :string
  end
end
