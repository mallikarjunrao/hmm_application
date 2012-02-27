# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  $crumbs = []

  def add_crumb(name, link)
    $crumbs << [name, link]
  end

  def get_crumbs(separator = '&raquo', start_text = false)
    if $crumbs.size
      out = []
      if start_text
        out << link_to(start_text, '/')
      end
      for crumb in $crumbs
        out << link_to(crumb[0], crumb[1])
      end
      return out.join(separator)
    else
      return null
    end
  end
  
end
