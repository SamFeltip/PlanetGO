# frozen_string_literal: true

class AddClicksToFaqs < ActiveRecord::Migration[7.0]
  def change
    add_column :faqs, :clicks, :integer, default: 0
  end
end
