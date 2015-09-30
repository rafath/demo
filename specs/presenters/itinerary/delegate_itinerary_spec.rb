require 'rails_helper'

describe Itinerary::DelegateItinerary do
  let!(:event) { create(:event) }
  let!(:supplier) { create(:supplier, an_event: event, reps: 1, companyname: 'Apple') }
  let!(:delegate) { create(:delegate, an_event: event) }
  let!(:delegate1) { create(:delegate, an_event: event) }
  let!(:slot1) { create(:slot, an_event: event, stime: 1100, etime: 1200, type: 'm') }
  let!(:slot2) { create(:slot, an_event: event, stime: 1200, etime: 1300, type: 'm') }
  let!(:slot3) { create(:slot, an_event: event, stime: 1300, etime: 1400, type: 'm') }
  let!(:slot4) { create(:slot, an_event: event, stime: 1400, etime: 1500, type: 'm') }
  let!(:workshop) { create(:workshop, an_event: event) }

  it 'contains proper entry for each appointment' do

    create(:appointment, an_event: event, a_delegate: delegate, a_supplier: supplier, a_slot: slot1)
    create(:appointment, an_event: event, a_delegate: delegate, a_supplier: supplier, a_slot: slot2)
    create(:appointment, an_event: event, a_delegate: delegate, a_supplier: supplier, a_slot: slot3)

    itinerary = Itinerary::DelegateItinerary.new(event, delegate)

    expect(itinerary).to be_kind_of(Itinerary::BaseItinerary)
    expect(itinerary.entries[1]).to include(Itinerary::DelegateItineraryMeetingEntry)
    expect(itinerary.entries[1].first.records).to include(Itinerary::DelegateItinerarySupplierAppointment)
    expect(itinerary.entries[1].last.records).to include(Itinerary::DelegateAppointmentGap)
    expect(itinerary.entries[1].first.records.first.to_s).to match(/Apple/)
    expect(itinerary.entries[1].last.records.first.to_s).to match(/Networking \/ Coffee Break/)
  end

  it 'contains Hotel Checkout entry' do
    event.update_attribute(:hotel_checkout_time, 1200)

    create(:appointment, an_event: event, a_delegate: delegate, a_supplier: supplier, a_slot: slot3)

    itinerary = Itinerary::DelegateItinerary.new(event, delegate)

    expect(itinerary.entries[1].first.records.first.to_s).to match(/Hotel Checkout/)
    expect(itinerary.entries[1].second.records.first.to_s).to match(/Networking \/ Coffee Break/)
    expect(itinerary.entries[1].third.records.first.to_s).to match(/Apple/)
    expect(itinerary.entries[1].last.records.first.to_s).to match(/Networking \/ Coffee Break/)
  end

  it 'contains workshop entry' do
    create(:workshop_attendance, a_delegate: delegate, a_workshop: workshop, an_event: event, a_slot: slot1)
    itinerary = Itinerary::DelegateItinerary.new(event, supplier)
    expect(itinerary.entries[1]).to include(Itinerary::DelegateItineraryWorkshopEntry)
    expect(itinerary.entries[1].first.records.first.to_s).to match(/Krav maga premier/)
  end
end