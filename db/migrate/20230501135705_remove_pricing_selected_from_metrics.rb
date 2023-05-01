# frozen_string_literal: true

class RemovePricingSelectedFromMetrics < ActiveRecord::Migration[7.0]
  def change
    remove_column :metrics, :pricing_selected, :integer
  end
end
