class AddDescriptionToPricings < ActiveRecord::Migration[7.0]
  def change
    add_column :pricings, :description, :string
  end
end
