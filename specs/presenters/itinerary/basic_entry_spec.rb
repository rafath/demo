require 'rails_helper'

describe Itinerary::BasicEntry do
  let!(:event) { create(:event) }
  let!(:supplier) { create(:supplier, an_event: event, reps: 1) }
  let!(:delegate) { create(:delegate, an_event: event) }
  let!(:slot) { create(:slot, an_event: event, stime: 1100, etime: 1200, type: 'm') }

  it 'implements proper methods' do

    entry = Itinerary::BasicEntry.new(slot)
    expect(entry.stime_string).to eq ('11:00')
    expect(entry.etime_string).to eq ('12:00')
    expect(entry.records).to be_an(Array)
  end
end