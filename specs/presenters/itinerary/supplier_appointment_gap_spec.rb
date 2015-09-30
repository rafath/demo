require 'rails_helper'

describe Itinerary::SupplierAppointmentGap do
  let!(:event) { create(:event) }
  let!(:supplier) { create(:supplier, an_event: event) }
  let!(:slot) { create(:slot, an_event: event) }

  it 'shows Hotel Checkout' do
    gap = Itinerary::SupplierAppointmentGap.new(slot, supplier)
    gap.is_hotel_checkout = true
    expect(gap.to_s).to eq 'Hotel Checkout'
  end

  it 'shows Networking Coffee break' do
    gap = Itinerary::SupplierAppointmentGap.new(slot, supplier)
    expect(gap.to_s).to match(/Networking \/ Coffee Break/)
  end
end