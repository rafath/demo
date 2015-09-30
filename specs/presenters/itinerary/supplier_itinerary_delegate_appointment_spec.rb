require 'rails_helper'

describe Itinerary::SupplierItineraryDelegateAppointment do
  let(:event) { create(:event) }
  let(:supplier) { create(:supplier, an_event: event, reps: 1) }
  let(:delegate) { create(:delegate, an_event: event) }
  let(:slot) { create(:slot, an_event: event, stime: 1100, etime: 1200, type: 'm') }
  let(:appointment) { create(:appointment, an_event: event, a_supplier: supplier, a_delegate: delegate, a_slot: slot) }

  it 'contains proper methods' do
    entry = Itinerary::SupplierItineraryDelegateAppointment.new(appointment)
    expect(entry.to_s).to match /#{delegate.companyname}/
    expect(entry.to_s).to match /#{delegate.firstname}/
    expect(entry.link_url).to be_a String
  end
end