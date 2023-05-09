# frozen_string_literal: true

class AddCachedVotes < ActiveRecord::Migration[7.0]
  def change
    change_table :proposed_events do |t|
      t.integer :cached_votes_total, default: 0
      t.integer :cached_votes, default: 0
    end

    change_table :events do |t|
      t.integer :cached_votes_total, default: 0
      t.integer :cached_votes, default: 0
    end

    ProposedEvent.find_each(&:update_cached_votes)
    Event.find_each(&:update_cached_votes)
  end
end
