class CreateOutings < ActiveRecord::Migration[7.0]
  def change
    create_table :outings do |t|
      t.string :name
      t.date :date
      t.text :description

      t.timestamps
    end
  end
end
