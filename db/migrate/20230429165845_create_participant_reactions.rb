class CreateParticipantReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :participant_reactions do |t|
      t.references :participant, null: false, foreign_key: true
      t.references :proposed_event, null: false, foreign_key: true
      t.integer :reaction

      t.timestamps
    end
  end
end
