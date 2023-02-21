# frozen_string_literal: true

# This migration adds the 'answered' and 'displayed' columns to the 'faqs' table.
class AddAnsweredAndDisplayedToFaqs < ActiveRecord::Migration[7.0]
  def change
    add_column :faqs, :answered, :boolean, default: false
    add_column :faqs, :displayed, :boolean, default: false
  end
end
