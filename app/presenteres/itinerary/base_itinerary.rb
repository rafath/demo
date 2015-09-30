class Itinerary::BaseItinerary

  attr_reader :model

  def initialize(event, model)
    @event = event
    @model = model
    @appointment_ranker = DelegateSupplierAppointmentRanker.new(event)
    mark_appointment_gaps_as_hotel_checkouts!
    mark_appointments_with_rank!
  end

  def entries
    @itinerary_entries ||= build_entries
  end

  def mark_appointments_with_rank!
    itinerary_appointment_records.each do |r|
      r.appointment_rank = @appointment_ranker.delegate_supplier_appointment_rank(r.appointment.delegate, r.appointment.supplier)
    end
  end

  private

  def appointment_gaps_before_hotel_checkout_deadline
    entries_before_checkout_deadline.map { |e| e.records.select { |r| r.kind_of?(Itinerary::AppointmentGap) } }.flatten
  end

  def entries_before_checkout_deadline
    entries_before_checkout = []
    entries.each_pair do |_day, day_entries|
      day_entries.each do |entry|
        entries_before_checkout << entry if @event.hotel_checkout_time_string > entry.stime_string
      end
    end
    entries_before_checkout
  end

  def itinerary_appointment_records
    appointment_records = []
    entries.each_pair do |_day, day_entries|
      day_entries.each do |entry|
        appointment_records << entry.records.select { |r| r.kind_of?(Itinerary::ItineraryAppointmentRecord) }
      end
    end
    appointment_records.flatten
  end
end
