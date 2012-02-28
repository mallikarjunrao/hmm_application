# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

# pagination helper 
# from http://www.igvita.com/blog/2006/09/10/faster-pagination-in-rails/
# depends on: http://cardboardrocket.com/pages/paginating_find

 def windowed_pagination_links(pagingEnum, options)
    link_to_current_page = options[:link_to_current_page]
    always_show_anchors = options[:always_show_anchors]
    padding = options[:window_size]

    current_page = pagingEnum.page
    html = ''

    #Calculate the window start and end pages 
    padding = padding < 0 ? 0 : padding
    first = pagingEnum.page_exists?(current_page  - padding) ? current_page - padding : 1
    last = pagingEnum.page_exists?(current_page + padding) ? current_page + padding : pagingEnum.last_page

    # Print start page if anchors are enabled
    html << yield(1) if always_show_anchors and not first == 1

    # Print window pages
    first.upto(last) do |page|
      (current_page == page && !link_to_current_page) ? html << page : html << yield(page)
    end

    # Print end page if anchors are enabled
    html << yield(pagingEnum.last_page) if always_show_anchors and not last == pagingEnum.last_page
    html
  end

		def to_bc(raw)
			BlueCloth.new(raw).to_html
		end

  def shorten (string, count = 30, addTip = false)
    if string.length >= count
      shortened = string[0, count]
      splitted = shortened.split(/\s/)
      words = splitted.length
      if words == 1
        words = 2
      end
      if addTip == true
        "<span style='color:blue;' title='" + string + "'>" + splitted[0, words-1].join(" ") + "...</span>"
      else
        splitted[0, words-1].join(" ") + "..."
      end
      
    else
      string
    end
  end

end
