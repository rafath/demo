class Itinerary::BasicEntry < Itinerary::AbstractEntry

  def initialize(slot)
    @slot = slot
  end

  def stime_string
    @slot.stime_string
  end

  def etime_string
    @slot.etime_string
  end

  def records
    [Itinerary::BasicRecord.new(@slot.title)]
  end
end