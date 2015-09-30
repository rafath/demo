require 'rails_helper'

describe Itinerary::AbstractEntry do
  let(:entry) { Itinerary::AbstractEntry.new }

  it 'raises error when call a method' do
    expect { entry.stime_string }.to raise_error(RuntimeError, 'abstract method called')
    expect { entry.etime_string }.to raise_error(RuntimeError, 'abstract method called')
    expect { entry.records }.to raise_error(RuntimeError, 'abstract method called')
  end
end