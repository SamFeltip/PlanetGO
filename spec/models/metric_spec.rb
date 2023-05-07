# frozen_string_literal: true

# == Schema Information
#
# Table name: metrics
#
#  id                  :bigint           not null, primary key
#  country_code        :string
#  is_logged_in        :boolean
#  latitude            :float
#  longitude           :float
#  number_interactions :integer
#  route               :string
#  time_enter          :datetime
#  time_exit           :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require 'rails_helper'
import DateTime

RSpec.describe Metric do
  include MetricsGraphHelper
  let(:event1) { create(:event) }
  let(:event2) { create(:event) }
  let(:event3) { create(:event) }
  let!(:outing1) { create(:outing) }

  describe 'helper_methods' do
    before do
      create(:proposed_event, event_id: event1.id, outing_id: outing1.id, proposed_datetime: '2023-02-23')
      create(:proposed_event, event_id: event2.id, outing_id: outing1.id, proposed_datetime: '2023-01-23')
      create(:proposed_event, event_id: event3.id, outing_id: outing1.id)
    end

    it 'selecting datetime with no events happening returns list with data full of zeros' do
      expect(handle_graph_category('2023-2-20', '2023-2-22', 'Day', 'Sport')).to eq(['["2023-02-20","2023-02-21"]', '[{"label":"Sport","data":[0,0]}]'])
    end

    it 'selecting datetime with 2 events happening return list with data containing two ones' do
      expect(handle_graph_category('2023-2-23', '2023-2-25', 'Day', 'Sport')).to eq(['["2023-02-23","2023-02-24"]', '[{"label":"Sport","data":[1,1]}]'])
    end

    it 'selecting datetime with 2 events happening but a different event name return list with data of zeros' do
      expect(handle_graph_category('2023-2-23', '2023-2-25', 'Day', 'Sport2')).to eq(['["2023-02-23","2023-02-24"]', '[{"label":"Sport2","data":[0,0]}]'])
    end

    it 'selecting datetime with 3 events happening on two separate months using the Month timescale returns data containing a two and a one' do
      expect(handle_graph_category('2023-1-1', '2023-3-1', 'Month', 'Sport')).to eq(['["2023-01-01","2023-02-01"]', '[{"label":"Sport","data":[1,2]}]'])
    end

    it 'selecting datetime with 3 events happening on two separate months using the Month timescale and the name All returns data containing a two and a one' do
      expect(handle_graph_category('2023-1-1', '2023-3-1', 'Month', 'All')).to eq(['["2023-01-01","2023-02-01"]', '[{"label":"Sport","data":[1,2]}]'])
    end
  end
end
