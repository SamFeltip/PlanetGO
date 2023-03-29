# frozen_string_literal: true

class ChangeOutingsCreatorIdNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:outings, :creator_id, false)
  end
end
