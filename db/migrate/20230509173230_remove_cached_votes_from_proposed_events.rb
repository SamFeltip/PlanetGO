# frozen_string_literal: true

class RemoveCachedVotesFromProposedEvents < ActiveRecord::Migration[7.0]
  def change
    remove_column :proposed_events, :cached_likes_total, :integer
    remove_column :proposed_events, :cached_likes, :integer
  end
end
