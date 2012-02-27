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

  # Contest - Global variables -- starts

  def contest_phase
    return "phase9"
  end

  def seniorcontest_phase
    return "phase10"
  end

  def seniorphoto_contest_name
    return "So Fabulous Seniors Photo Contest"
  end

  def seniorphoto_contest_image
    return "/images/seniors_contest/seniors-logo1.png"
  end

  def photo_contest_name
    return "Glamour Photo Contest"
  end
  def video_contest_name
    return "Glamour Video Contest"
  end
  def photo_contest_image
    return "/images/glamour_contest/all-glammed-up-logo_black.png"
  end
  def video_contest_image
    return "/images/glamour_contest/all-glammed-up-logo_black.png"
  end
  def photo_contest_smallimage
    return "thats_my_baby.gif"
  end
  def video_contest_smallimage
    return "thats_my_baby_video.gif"
  end

  #  def seniorphoto_contest_image
  #    return "/images/seniors_contest/seniors-logo.png"
  #  end
  # Contest - Global variables -- ends

  def iphone_request?
    return (request.user_agent.include?("iPhone") || (request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]) || request.env["HTTP_USER_AGENT"][/(Android)/])
  end

end