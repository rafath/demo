require 'rails_helper'

describe Itinerary::AbstractRecord do
  let(:record) { Itinerary::AbstractRecord.new }

  it 'raises error when call a method' do
    expect { record.link_url }.to raise_error(RuntimeError, 'abstract method called')
    expect { record.to_s }.to raise_error(RuntimeError, 'abstract method called')
  end
end