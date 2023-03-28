class RemoveCategoryFromEvent < ActiveRecord::Migration[7.0]
  def change
    remove_column :events, :category, :integer
  end
end
