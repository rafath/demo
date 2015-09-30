class Itinerary::SupplierItineraryDelegateAppointment < Itinerary::ItineraryAppointmentRecord

  include Draper::ViewHelpers

  def link_html
    h.raw(format("%s (%s)", h.link_to(company_name, link_url), delegate_names))
  end

  def to_s
    [company_name, delegate_names].join(' ')
  end

  def link_url
    h.admin_event_supplier_itinerary_supplier_appointment_url(@appointment.an_event, @appointment.a_supplier, @appointment.id)
  end

  private

  def company_name
    @appointment.a_delegate.companyname
  end

  def delegate_names
    names = [@appointment.a_delegate.name]
    if @appointment.a_delegate.has_partners?
      @appointment.a_delegate.partners.map { |dp| names << dp.name }
    end
    names.join(', ')
  end
end