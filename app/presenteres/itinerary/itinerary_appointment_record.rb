class Itinerary::ItineraryAppointmentRecord

  attr_accessor :appointment_rank
  attr_reader :appointment

  def initialize(appointment)
    @appointment = appointment
  end

end