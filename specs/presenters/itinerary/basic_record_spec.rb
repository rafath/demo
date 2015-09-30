require 'rails_helper'

describe Itinerary::BasicRecord do
  let!(:event) { create(:event) }
  let!(:supplier) { create(:supplier, an_event: event, reps: 1) }
  let!(:delegate) { create(:delegate, an_event: event) }
  let!(:slot) { create(:slot, an_event: event, stime: 1100, etime: 1200, type: 'm', title: 'Some meeting') }

  it 'implements proper methods' do

    record = Itinerary::BasicRecord.new(slot.title)
    expect(record.to_s).to eq ('Some meeting')
    expect(record.link_url).to be_nil
  end
end