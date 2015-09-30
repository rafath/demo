class Itinerary::SupplierItinerary < Itinerary::BaseItinerary

  private

  def build_entries
    slots = @event.slots.for_suppliers.order('day, stime')
    day_slots = {}
    slots.each do |slot|
      day_slots[slot.day] ||= []
      if slot.is_meeting?
        day_slots[slot.day] << Itinerary::SupplierItineraryMeetingEntry.new(slot, @model)
      else
        day_slots[slot.day] << Itinerary::BasicEntry.new(slot)
      end
    end
    day_slots
  end

  def mark_appointment_gaps_as_hotel_checkouts!
    appointment_gaps_before_hotel_checkout_deadline.take(@model.reps).each { |ag| ag.is_hotel_checkout = true }
  end
end