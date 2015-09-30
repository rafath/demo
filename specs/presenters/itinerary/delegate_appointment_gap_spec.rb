require 'rails_helper'

describe Itinerary::DelegateAppointmentGap do
  let!(:event) { create(:event) }
  let!(:delegate) { create(:delegate, an_event: event) }
  let!(:slot) { create(:slot, an_event: event) }


  it 'shows Hotel Checkout' do
    gap = Itinerary::DelegateAppointmentGap.new(slot, delegate)
    gap.is_hotel_checkout = true
    expect(gap.to_s).to eq 'Hotel Checkout'
  end


  it 'shows Networking Coffee break' do
    gap = Itinerary::DelegateAppointmentGap.new(slot, delegate)
    expect(gap.to_s).to match ('Networking / Coffee Break')
  end

end