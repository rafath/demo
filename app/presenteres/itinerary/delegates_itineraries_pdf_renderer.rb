class Itinerary::DelegatesItinerariesPdfRenderer < Itinerary::ItinerariesPdfRenderer

  def load_itineraries
    itineraries = []
    @models.each do |model|
      itineraries << Itinerary::DelegateItinerary.new(@event, model)
    end
    itineraries
  end

  def filename
    if @models.size > 1
      "Delegate itineraries - #{@event.name}.pdf"
    else
      "Delegate Itinerary - #{@models.first.full_display_name} - #{@event.name}.pdf"
    end
  end
end