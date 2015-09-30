require 'rails_helper'

describe Itinerary::SupplierItinerary do
  let!(:event) { create(:event) }
  let!(:supplier) { create(:supplier, an_event: event, reps: 1) }
  let!(:delegate) { create(:delegate, an_event: event, companyname: 'Dell') }
  let!(:slot1) { create(:slot, an_event: event, stime: 1100, etime: 1200, type: 'm') }
  let!(:slot2) { create(:slot, an_event: event, stime: 1200, etime: 1300, type: 'm') }
  let!(:slot3) { create(:slot, an_event: event, stime: 1300, etime: 1400, type: 'm') }
  let!(:slot4) { create(:slot, an_event: event, stime: 1400, etime: 1500, type: 'm') }

  it 'contains proper entry for each appointmet' do

    create(:appointment, an_event: event, a_delegate: delegate, a_supplier: supplier, a_slot: slot1)
    create(:appointment, an_event: event, a_delegate: delegate, a_supplier: supplier, a_slot: slot2)
    create(:appointment, an_event: event, a_delegate: delegate, a_supplier: supplier, a_slot: slot3)

    itinerary = Itinerary::SupplierItinerary.new(event, supplier)

    expect(itinerary).to be_kind_of(Itinerary::BaseItinerary)
    expect(itinerary.entries[1]).to include(Itinerary::SupplierItineraryMeetingEntry)
    expect(itinerary.entries[1].first.records).to include(Itinerary::SupplierItineraryDelegateAppointment)
    expect(itinerary.entries[1].last.records).to include(Itinerary::SupplierAppointmentGap)
    expect(itinerary.entries[1].first.records.first.to_s).to match(/Dell/)
    expect(itinerary.entries[1].last.records.first.to_s).to match(/Networking \/ Coffee Break/)
  end

  it 'contains Hotel Checkout entry' do

    event.update_attribute(:hotel_checkout_time, 1200)

    create(:appointment, an_event: event, a_delegate: delegate, a_supplier: supplier, a_slot: slot3)

    itinerary = Itinerary::SupplierItinerary.new(event, supplier)

    expect(itinerary.entries[1].first.records.first.to_s).to match(/Hotel Checkout/)
    expect(itinerary.entries[1].second.records.first.to_s).to match(/Networking \/ Coffee Break/)
    expect(itinerary.entries[1].third.records.first.to_s).to match(/Dell/)
    expect(itinerary.entries[1].last.records.first.to_s).to match(/Networking \/ Coffee Break/)
  end

  it 'contains Hotel Checkout entry for each rep' do

    supplier.update_attribute(:reps, 3)
    event.update_attribute(:hotel_checkout_time, 1200)
    delegate2 = create(:delegate, an_event: event, companyname: 'HP')
    delegate3 = create(:delegate, an_event: event, companyname: 'Apple')

    create(:appointment, an_event: event, a_delegate: delegate, a_supplier: supplier, a_slot: slot3)
    create(:appointment, an_event: event, a_delegate: delegate3, a_supplier: supplier, a_slot: slot3)
    create(:appointment, an_event: event, a_delegate: delegate2, a_supplier: supplier, a_slot: slot3)

    itinerary = Itinerary::SupplierItinerary.new(event, supplier)

    expect(itinerary.entries[1].first.records.first.to_s).to match(/Hotel Checkout/)
    expect(itinerary.entries[1].first.records.second.to_s).to match(/Hotel Checkout/)
    expect(itinerary.entries[1].first.records.third.to_s).to match(/Hotel Checkout/)
    expect(itinerary.entries[1].second.records.first.to_s).to match(/Networking \/ Coffee Break/)
    expect(itinerary.entries[1].second.records.second.to_s).to match(/Networking \/ Coffee Break/)
    expect(itinerary.entries[1].second.records.third.to_s).to match(/Networking \/ Coffee Break/)
    expect(itinerary.entries[1].third.records.first.to_s).to match(/Dell/)
    expect(itinerary.entries[1].third.records.second.to_s).to match(/Apple/)
    expect(itinerary.entries[1].third.records.third.to_s).to match(/HP/)
  end

  it 'is marked with match rank type', focus: true do
    delegate2 = create(:delegate, an_event: event)
    delegate3 = create(:delegate, an_event: event)
    delegate4 = create(:delegate, an_event: event)
    delegate5 = create(:delegate, an_event: event)
    delegate6 = create(:delegate, an_event: event)

    supplier2 = create(:supplier, an_event: event)
    supplier3 = create(:supplier, an_event: event)

    create(:supplier_preference, supplier_object: supplier, delegate_object: delegate, rank: 1)
    create(:supplier_preference, supplier_object: supplier, delegate_object: delegate2, rank: 1)
    create(:supplier_preference, supplier_object: supplier, delegate_object: delegate4, rank: 1)
    create(:supplier_preference, supplier_object: supplier2, delegate_object: delegate5, rank: 1)
    create(:supplier_preference, supplier_object: supplier3, delegate_object: delegate6, rank: 1)

    create(:delegate_preference, supplier_object: supplier, delegate_object: delegate, rank: 1)
    create(:delegate_preference, supplier_object: supplier, delegate_object: delegate2, rank: 1)
    create(:delegate_preference, supplier_object: supplier, delegate_object: delegate3, rank: 1)
    create(:delegate_preference, supplier_object: supplier2, delegate_object: delegate4, rank: 1)
    create(:delegate_preference, supplier_object: supplier2, delegate_object: delegate5, rank: 1)
    create(:delegate_preference, supplier_object: supplier3, delegate_object: delegate6, rank: 1)

    create(:appointment, an_event: event, a_delegate: delegate, a_supplier: supplier, a_slot: slot1)
    create(:appointment, an_event: event, a_delegate: delegate2, a_supplier: supplier, a_slot: slot2)
    create(:appointment, an_event: event, a_delegate: delegate4, a_supplier: supplier, a_slot: slot3)
    create(:appointment, an_event: event, a_delegate: delegate5, a_supplier: supplier, a_slot: slot4)

    itinerary = Itinerary::SupplierItinerary.new(event, supplier)
    entry = itinerary.entries[1]

    expect(entry[0].records.first.appointment_rank).to eq :direct
    expect(entry[1].records.first.appointment_rank).to eq :direct
    expect(entry[2].records.first.appointment_rank).to eq :single
    expect(entry[3].records.first.appointment_rank).to eq :none
  end
end