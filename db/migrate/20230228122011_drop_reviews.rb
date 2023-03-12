# frozen_string_literal: true

class DropReviews < ActiveRecord::Migration[7.0]
  def change
    drop_table :reviews do |t|
      t.text :body
      t.string :answer
      t.boolean :is_on_landing_page, default: false
      t.integer :landing_page_position
      t.integer :clicks, default: 0
      t.index :user_id, name: 'index_reviews_on_user_id'

      t.timestamps
    end
  end
end
