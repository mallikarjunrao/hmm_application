module UserAccountHelper
  def request_server_url
    @host_name = request.host_with_port
    if(@host_name == 'www.holdmymemories.com' || @host_name == 'holdmymemories.com')
      @server_url_chk = 'http://holdmymemories.com'
      return  @server_url_chk;
    elsif(@host_name == 'localhost' || @host_name == '127.0.0.1')
      @server_url_chk = 'http://localhost'
      return  @server_url_chk;
    elsif(@host_name == 'www.staging.holdmymemories.com' || @host_name == 'staging.holdmymemories.com' )
      @server_url_chk = 'http://staging.holdmymemories.com'
       return  @server_url_chk;
    elsif(@host_name == 'golive.holdmymemories.com')
      @server_url_chk = 'http://golive.holdmymemories.com'
      return  @server_url_chk;
    elsif(@host_name == '38.114.213.188' || @host_name == '38.114.213.188/')
      @server_url_chk = 'http://38.114.213.188'
    elsif(@host_name == '192.168.4.184:3000' || @host_name == '192.168.4.184/')
      @server_url_chk = 'http://192.168.4.184:3000'

      return  @server_url_chk;
    end
  end

  def request_content_url
    @host_name = request.host_with_port
    if(@host_name == 'www.holdmymemories.com' || @host_name == 'holdmymemories.com')
      @content_url_chk = 'http://content.holdmymemories.com'
      return  @content_url_chk;
    elsif(@host_name == 'localhost:3000' || @host_name == '127.0.0.1:3000')
      @content_url_chk = 'http://localhost:3001'
      return  @content_url_chk;
    elsif(@host_name == 'www.staging.holdmymemories.com' || @host_name == 'staging.holdmymemories.com' || @host_name == 'golive.holdmymemories.com')
      @content_url_chk = 'http://stagingcontent.holdmymemories.com'
      return  @content_url_chk;
        
    elsif(@host_name == '38.114.213.188' || @host_name == '38.114.213.188/')
      @content_url_chk = 'http://38.114.213.189'
      return  @content_url_chk;
    end

  end

  def request_https_server_url
    @host_name = request.host_with_port
    if(@host_name == 'www.holdmymemories.com' || @host_name == 'holdmymemories.com' )
      @server_url_chk = 'https://holdmymemories.com'
      return  @server_url_chk;
    elsif(@host_name == 'localhost' || @host_name == '127.0.0.1')
      @server_url_chk = 'http://localhost'
      return  @server_url_chk;
    elsif(@host_name == 'www.staging.holdmymemories.com' || @host_name == 'staging.holdmymemories.com')
      @server_url_chk = 'https://staging.holdmymemories.com'

      return  @server_url_chk;
       elsif(@host_name == 'golive.holdmymemories.com')
      @server_url_chk = 'http://golive.holdmymemories.com'
      return  @server_url_chk;
    elsif(@host_name == '38.114.213.188' || @host_name == '38.114.213.188/')
      @server_url_chk = 'http://38.114.213.188'
    elsif(@host_name == '192.168.4.184:3000' || @host_name == '192.168.4.184/')
      @server_url_chk = 'http://192.168.4.184:3000'

      return  @server_url_chk;
    end
  end

 
  def request_https_content_url
    @host_name = request.host_with_port
    if(@host_name == 'www.holdmymemories.com' || @host_name == 'holdmymemories.com' || @host_name == 'myhmm.com' || @host_name == 'www.myhmm.com')
      @content_url_chk = 'https://content.holdmymemories.com'
      return  @content_url_chk;
    elsif(@host_name == 'localhost:3000' || @host_name == '127.0.0.1:3000')
      @content_url_chk = 'http://localhost:3001'
      return  @content_url_chk;
    elsif(@host_name == 'www.staging.holdmymemories.com' || @host_name == 'staging.holdmymemories.com' || @host_name == 'golive.holdmymemories.com')
      @content_url_chk = 'https://stagingcontent.holdmymemories.com'
      return  @content_url_chk;
    elsif(@host_name == '38.114.213.188' || @host_name == '38.114.213.188/')
      @content_url_chk = 'https://38.114.213.189'
      return  @content_url_chk;
    end

  end

  # Global variable -- print_size table -- id -- for high_resolution & low_resulition
  def high_resolution
    @host_name = request.host_with_port
    if(@host_name == 'www.staging.holdmymemories.com' || @host_name == 'staging.holdmymemories.com')
      9
    else
      25
    end

  end

  def low_resolution

    @host_name = request.host_with_port
    if(@host_name == 'www.staging.holdmymemories.com' || @host_name == 'staging.holdmymemories.com')
     10
    else
      26
    end
  end
end






