class Itinerary::ItinerariesPdfRenderer

  def initialize(event, models, controller)
    @event = event
    @models = models
    @controller = controller
  end

  def build_pdf
    pdf_kit = PDFKit.new(render_view, print_media_type: true, page_size: 'Letter')
    pdf_kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/pdf.scss"
    pdf_kit.to_pdf
  end

  private

  def render_view
    @controller.render_to_string(layout: 'admin/pdf', template: 'admin/itineraries/export_pdf.html.haml', locals: {itineraries: load_itineraries})
  end

end