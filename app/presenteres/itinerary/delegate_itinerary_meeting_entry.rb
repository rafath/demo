class Itinerary::DelegateItineraryMeetingEntry < Itinerary::AbstractEntry

  def initialize(slot, delegate)
    @slot = slot
    @delegate = delegate
    @meetings = []
    build_suppliers
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

  def build_suppliers
    appointments = Appointment.where(slot: @slot, delegate: @delegate).includes(:a_supplier)
    if appointments.blank?
      @meetings << Itinerary::DelegateAppointmentGap.new(@slot, @delegate)
    else
      appointments.each do |appointment|
        @meetings << Itinerary::DelegateItinerarySupplierAppointment.new(appointment)
      end
    end
  end
end