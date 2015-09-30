class Itinerary::SupplierItineraryMeetingEntry < Itinerary::AbstractEntry

  def initialize(slot, supplier)
    @slot = slot
    @supplier = supplier
    @meetings = []
    build_delegates
    fill_appointment_gaps
  end

  def records
    @meetings
  end

  def stime_string
    @slot.stime_string
  end

  def etime_string
    @slot.etime_string
  end

  private

  def build_delegates
    Appointment.where(slot: @slot, supplier: @supplier).includes(:a_delegate).each do |appointment|
      @meetings << Itinerary::SupplierItineraryDelegateAppointment.new(appointment)
    end
  end

  def fill_appointment_gaps
    free_reps = @supplier.number_of_free_reps_for_slot(@slot)
    @meetings.fill(@meetings.size, free_reps) { Itinerary::SupplierAppointmentGap.new(@slot, @supplier) } if free_reps
  end
end