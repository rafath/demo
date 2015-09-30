require 'rails_helper'

describe Itinerary::DelegateItineraryWorkshopEntry do
  let(:event) { create(:event) }
  let(:workshop) { create(:workshop, an_event: event, stime: 1100, etime: 1200, title: 'Photoshop workshop') }
  let(:entry) { Itinerary::DelegateItineraryWorkshopEntry.new(workshop) }

  it 'has start time' do
    expect(entry.stime_string).to eq '11:00'
  end

  it 'has end time' do
    expect(entry.etime_string).to eq '12:00'
  end

  it 'has records' do
    expect(entry.records).to be_an(Array)
    expect(entry.records.first).to be_kind_of Itinerary::BasicRecord
    expect(entry.records.first.to_s).to eq 'Photoshop workshop'
  end
end