class CreateProposedEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :proposed_events do |t|
      t.references :event, null: false, foreign_key: true
      t.references :outing, null: false, foreign_key: true
      t.datetime :proposed_datetime
      t.integer :status

      t.timestamps
    end
  end
end
