class Itinerary::SupplierAppointmentGap < Itinerary::AppointmentGap

  def link_url
    h.new_admin_event_supplier_itinerary_supplier_appointments_url(@slot.event, @model.id, @slot.id)
  end
end