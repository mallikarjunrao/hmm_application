module FamilyMemoryHelper

    def request_server_url
    @host_name = request.host_with_port
    if(@host_name == 'www.holdmymemories.com' || @host_name == 'holdmymemories.com')
      @server_url_chk = 'http://holdmymemories.com'
      return  @server_url_chk;
    elsif(@host_name == 'localhost' || @host_name == '127.0.0.1')
      @server_url_chk = 'http://localhost'
      return  @server_url_chk;
    elsif(@host_name == 'www.staging.holdmymemories.com' || @host_name == 'staging.holdmymemories.com')
      @server_url_chk = 'http://staging.holdmymemories.com'

      return  @server_url_chk;
    elsif(@host_name == '38.114.213.188' || @host_name == '38.114.213.188/')
      @server_url_chk = 'http://38.114.213.188'
    elsif(@host_name == '192.168.4.184:3000' || @host_name == '192.168.4.184/')
      @server_url_chk = 'http://192.168.4.184:3000'

      return  @server_url_chk;
    end
  end

    def pp_studio_group
     1
    end

end