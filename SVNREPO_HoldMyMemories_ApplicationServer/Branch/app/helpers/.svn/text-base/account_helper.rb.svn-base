module AccountHelper
  
   def pagination_links_remote_statistic(paginator)
  page_options = {:window_size => 1}
  pagination_links_each(paginator, page_options) do |n|
    options = {
      :url => {:action => 'statistic_report', :params => params.merge({:page => n})},
      :update => 'content',
      :before => "Element.show('spinner')",
      :success => "Element.hide('spinner')"
    }
    html_options = {:href => url_for(:action => 'list', :params => params.merge({:page => n}))}
    link_to_remote(n.to_s, options, html_options)
  end
end
 

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


def sort_td_class_helper(param)
  result = 'class="sortup"' if params[:sort] == param
  result = 'class="sortdown"' if params[:sort] == param + "_reverse"
  return result
end

 def nice_date(date)
    h date.strftime("%Y-%m-%d ")
  end

  
end
