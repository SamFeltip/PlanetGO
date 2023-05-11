# frozen_string_literal: true

class ChangeDataTypeForDateInOutings < ActiveRecord::Migration[7.0]
  def self.up
    change_table :outings do |t|
      t.change :date, :datetime
    end
  end

  def self.down
    change_table :outings do |t|
      t.change :date, :date
    end
  end
end
