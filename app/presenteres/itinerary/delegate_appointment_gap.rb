class Itinerary::DelegateAppointmentGap < Itinerary::AppointmentGap

  def link_url
    h.new_admin_event_delegate_itinerary_delegate_appointments_url(@slot.event, @model.id, @slot.id)
  end
end