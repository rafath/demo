require 'rails_helper'

describe Itinerary::DelegateItinerarySupplierAppointment do
  let(:event) { create(:event) }
  let(:supplier) { create(:supplier, an_event: event, reps: 1, companyname: 'Apple', firstname: 'Steve', surname: 'Jobs') }
  let(:delegate) { create(:delegate, an_event: event) }
  let(:slot) { create(:slot, an_event: event, stime: 1100, etime: 1200, type: 'm') }
  let(:appointment) { create(:appointment, an_event: event, a_supplier: supplier, a_delegate: delegate, a_slot: slot) }

  it 'returns link appointment edit page' do
    entry = Itinerary::DelegateItinerarySupplierAppointment.new(appointment)
    expect(entry.link_html).to match /\/admin\/events\/\d+\/delegate_itineraries\/\d+\/delegate_appointments\/\d+/
  end

  it 'reports a string with supplier full name' do
    entry = Itinerary::DelegateItinerarySupplierAppointment.new(appointment)
    expect(entry.to_s).to match /Apple/
    expect(entry.to_s).to match /Steve Jobs/
  end
end