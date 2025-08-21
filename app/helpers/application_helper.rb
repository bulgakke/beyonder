module ApplicationHelper
  def show_image(attachment, variant, **options)
    if attachment.present?
      image_tag(url_for(attachment.variant(variant)), **options)
    else
      image_tag("placeholder.svg", **options)
    end
  end
end
