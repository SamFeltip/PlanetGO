class AddChangeEventTypeName < ActiveRecord::Migration[7.0]
  def change
    add_column :outings, :outing_type, :integer
    remove_column :outings, :event_type
  end
end
