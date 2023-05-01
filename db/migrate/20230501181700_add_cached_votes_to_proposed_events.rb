class AddCachedVotesToProposedEvents < ActiveRecord::Migration[7.0]
  def change
    change_table :proposed_events do |t|
      t.integer :cached_likes_total, default: 0
      t.integer :cached_likes, default: 0
    end

    # Uncomment this line to force caching of existing votes
    # Post.find_each(&:update_cached_votes)
  end
end