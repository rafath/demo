class Itinerary::DelegateItinerarySupplierAppointment < Itinerary::ItineraryAppointmentRecord

  include Draper::ViewHelpers

  def link_html
    h.raw(format("%s (%s)", h.link_to(@appointment.a_supplier.company_name, link_url), @appointment.a_supplier.name))
  end

  def to_s
    [@appointment.a_supplier.company_name, @appointment.a_supplier.name].join(' ')
  end

  private

  def link_url
    h.admin_event_delegate_itinerary_delegate_appointment_url(@appointment.event, @appointment.delegate, @appointment.id)
  end
end