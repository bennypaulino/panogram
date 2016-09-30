module ApplicationHelper
  # Returns a title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Because the world isn't always square"
    default_page_title = "Panogram"
    if page_title.empty?
      default_page_title + " | " + base_title
    else
     page_title + " | " + base_title
    end
  end

  # Allow validation fields to have a red glow by adding the proper class
  def form_group_tag(errors, &block)
    if errors.any?
      content_tag :div, capture(&block), class: 'form-group has-error'
    else
      content_tag :div, capture(&block), class: 'form-group'
    end
  end
end
