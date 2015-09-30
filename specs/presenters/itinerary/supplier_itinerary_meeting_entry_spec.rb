require 'rails_helper'

describe Itinerary::SupplierItineraryMeetingEntry do
  let!(:event) { create(:event) }
  let!(:supplier) { create(:supplier, an_event: event, reps: 1) }
  let!(:delegate) { create(:delegate, an_event: event) }
  let!(:slot) { create(:slot, an_event: event, stime: 1100, etime: 1200, type: 'm') }
  let!(:entry) { Itinerary::SupplierItineraryMeetingEntry.new(slot, supplier) }

  it 'inherits from abstract class' do
    expect(entry).to be_kind_of(Itinerary::AbstractEntry)
  end

  it 'has start time' do
    expect(entry.stime_string).to eq '11:00'
  end

  it 'has end time' do
    expect(entry.etime_string).to eq '12:00'
  end

  it 'has records' do
    expect(entry.records).to be_an Array
    expect(entry.records).to include(Itinerary::SupplierAppointmentGap)
  end
end