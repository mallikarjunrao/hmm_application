module CustomersHelper
 
  def pagination_links_remote_fnf(paginator)
  page_options = {:window_size => 1}
  pagination_links_each(paginator, page_options) do |n|
    options = {
      :url => {:action => 'fnf_index', :params => params.merge({:page => n})},
      :update => 'table',
      :before => "Element.show('spinner')",
      :success => "Element.hide('spinner')"
    }
    html_options = {:href => url_for(:action => 'list', :params => params.merge({:page => n}))}
    link_to_remote(n.to_s, options, html_options)
  end
end
 
  
  def pagination_links_remote(paginator)
  page_options = {:window_size => 1}
  pagination_links_each(paginator, page_options) do |n|
    options = {
      :url => {:action => 'chapterindex', :params => params.merge({:page => n})},
      :update => 'table',
      :before => "Element.show('spinner')",
      :success => "Element.hide('spinner')"
    }
    html_options = {:href => url_for(:action => 'list', :params => params.merge({:page => n}))}
    link_to_remote(n.to_s, options, html_options)
  end
end

def pagination_moments_remote(paginator)
  page_options = {:window_size => 1}
  pagination_links_each(paginator, page_options) do |n|
    options = {
      :url => {:action => 'chapter_next', :params => params.merge({:page => n})},
      :update => 'moments_table',
      :before => "Element.show('spinner')",
      :success => "Element.hide('spinner')"
    }
    html_options = {:href => url_for(:action => 'list', :params => params.merge({:page => n}))}
    link_to_remote(n.to_s, options, html_options)
  end
end

def pagination_links_remote_fnf(paginator)
  page_options = {:window_size => 10}
  pagination_links_each(paginator, page_options) do |n|
    options = {
      :url => {:action => 'fnf_index', :params => params.merge({:page => n})},
      :update => 'table',
      :before => "Element.show('spinner')",
      :success => "Element.hide('spinner')"
    }
    html_options = {:href => url_for(:action => 'list', :params => params.merge({:page => n}))}
    link_to_remote(n.to_s, options, html_options)
  end
end

def pagination_links_remote_chap_gallery(paginator)
  page_options = {:window_size => 1}
  pagination_links_each(paginator, page_options) do |n|
    options = {
      :url => {:action => 'chapter_gallery', :params => params.merge({:page => n})},
      :update => 'table',
      :before => "Element.show('spinner')",
      :success => "Element.hide('spinner')"
    }
    html_options = {:href => url_for(:action => 'list', :params => params.merge({:page => n}))}
    link_to_remote(n.to_s, options, html_options)
  end
end


def sort_td_class_helper(param)
  result = 'class="sortup"' if params[:sort] == param
  result = 'class="sortdown"' if params[:sort] == param + "_reverse"
  return result
end





end
