# frozen_string_literal: true

class DropRegisterInterests < ActiveRecord::Migration[7.0]
  def change
    drop_table :register_interests do |t|
      t.string :email
      t.string :pricing_id
      t.string :pricing_plan_id
    end
  end
end
