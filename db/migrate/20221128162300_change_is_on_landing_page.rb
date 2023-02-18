# frozen_string_literal: true

class ChangeIsOnLandingPage < ActiveRecord::Migration[7.0]
  def change
    change_column :reviews, :is_on_landing_page, :boolean, default: false
  end
end
