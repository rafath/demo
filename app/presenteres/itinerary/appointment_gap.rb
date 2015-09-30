class Itinerary::AppointmentGap < Draper::Decorator

  attr_accessor :is_hotel_checkout

  def initialize(slot, model)
    @slot = slot
    @model = model
  end

  def link_html
    h.raw(h.link_to self.to_s, link_url)
  end

  def to_s
    if is_hotel_checkout
      'Hotel Checkout'
    else
      'Networking / Coffee Break'
    end
  end

  def link_url
    raise 'abstract method call'
  end

end