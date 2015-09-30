class Itinerary::DelegateItineraryWorkshopEntry < Itinerary::AbstractEntry

  def initialize(workshop)
    @workshop = workshop
  end

  def records
    [Itinerary::BasicRecord.new(@workshop.title)]
  end

  def stime_string
    @workshop.stime_string
  end

  def etime_string
    @workshop.etime_string
  end
end