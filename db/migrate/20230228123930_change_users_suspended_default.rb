# frozen_string_literal: true

class ChangeUsersSuspendedDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :suspended, from: nil, to: false
  end
end
