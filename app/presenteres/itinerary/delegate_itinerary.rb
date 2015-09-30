class Itinerary::DelegateItinerary < Itinerary::BaseItinerary

  private

  def build_entries
    @day_slots = {}
    workshop_entries
    slot_entries
    sort_entries!
    @day_slots
  end

  def workshop_entries
    delegate_workshops.each do |workshop|
      @day_slots[workshop.a_workshop.day] ||= []
      @day_slots[workshop.a_workshop.day] << Itinerary::DelegateItineraryWorkshopEntry.new(workshop.a_workshop)
    end
  end

  def slot_entries
    slots = @event.slots.for_delegates.order('day, stime')
    slots.each do |slot|
      @day_slots[slot.day] ||= []
      unless any_workshop_overlaps_slot?(slot)
        if slot.is_meeting?
          @day_slots[slot.day] << Itinerary::DelegateItineraryMeetingEntry.new(slot, @model)
        else
          @day_slots[slot.day] << Itinerary::BasicEntry.new(slot)
        end
      end
    end
  end

  def sort_entries!
    @day_slots.each_pair do |k, _v|
      @day_slots[k].sort! { |a, b| a.stime_string <=> b.stime_string }
    end
  end

  def any_workshop_overlaps_slot?(slot)
    time_entries = TimeEntries.new
    delegate_workshops.each do |dw|
      if slot.day == dw.a_workshop.day && time_entries.are_overlaping?(slot.stime, slot.etime, dw.a_workshop.stime, dw.a_workshop.etime)
        return true
      end
    end
    false
  end

  def delegate_workshops
    @workshops ||= @event.workshop_attendances.includes(:a_workshop).order('workshops.day, workshops.stime')
  end

  def mark_appointment_gaps_as_hotel_checkouts!
    appointment_gaps_before_hotel_checkout_deadline.take(1).each { |ag| ag.is_hotel_checkout = true }
  end

end