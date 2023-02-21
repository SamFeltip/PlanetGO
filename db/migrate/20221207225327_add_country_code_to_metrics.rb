# frozen_string_literal: true

class AddCountryCodeToMetrics < ActiveRecord::Migration[7.0]
  def change
    add_column :metrics, :country_code, :string
  end
end
