# frozen_string_literal: true

class DropFaqs < ActiveRecord::Migration[7.0]
  def change
    drop_table :faqs do |t|
      t.string :question
      t.string :answer
      t.boolean :answered, default: false
      t.boolean :displayed, default: false
      t.integer :clicks, default: 0

      t.timestamps
    end
  end
end
