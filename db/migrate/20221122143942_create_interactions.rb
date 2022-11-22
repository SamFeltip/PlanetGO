class CreateInteractions < ActiveRecord::Migration[7.0]
  def change
    create_table :interactions do |t|
      t.boolean :logged_in
      t.timestamp :start_visit
      t.float :lattitude
      t.float :longitude
      t.timestamp :start_splashscreen
      t.integer :time_on_splashscreen
      t.integer :num_interactions_on_splashscreen

      t.timestamps
    end
  end
end
