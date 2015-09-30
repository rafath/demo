class Itinerary::BasicRecord < Itinerary::AbstractRecord

  def initialize(title)
    @title = title
  end

  def link_html
    self.to_s
  end

  def to_s
    @title
  end

  def link_url
    nil
  end
end