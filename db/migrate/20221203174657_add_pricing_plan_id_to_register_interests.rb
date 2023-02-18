# frozen_string_literal: true

class AddPricingPlanIdToRegisterInterests < ActiveRecord::Migration[7.0]
  def change
    add_column :register_interests, :pricing_plan_id, :string
  end
end
