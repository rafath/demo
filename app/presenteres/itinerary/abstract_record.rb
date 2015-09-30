class Itinerary::AbstractRecord

  def link_html
    raise 'abstract method called'
  end

  def to_s
    raise 'abstract method called'
  end

  def link_url
    raise 'abstract method called'
  end
end