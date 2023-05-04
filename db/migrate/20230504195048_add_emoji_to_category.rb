class AddEmojiToCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :symbol, :string
  end
end