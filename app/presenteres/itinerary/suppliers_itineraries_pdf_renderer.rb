class Itinerary::SuppliersItinerariesPdfRenderer < Itinerary::ItinerariesPdfRenderer

  def load_itineraries
    itineraries = []
    @models.each do |model|
      itineraries << Itinerary::SupplierItinerary.new(@event, model)
    end
    itineraries
  end

  def filename
    if @models.size > 1
      "Supplier itineraries - #{@event.name}.pdf"
    else
      "Supplier Itinerary - #{@models.first.full_display_name} - #{@event.name}.pdf"
    end
  end
end