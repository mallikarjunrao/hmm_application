require 'rubygems'

require 'oauth'

require 'oauth/consumer'

require 'ruby-debug'

require 'json'

API_KEY = "149832372"

API_KEY_PRIVATE = "2a7c351b90c386d9446f33826c8d4c9c"

USERNAME = "mallikarjunarao786"

USERNAME_PW = "9848012345"

#patch to override api.photobucket.com in SBS
module OAuth::RequestProxy
    class Base
        def normalized_uri
            u = URI.parse(uri)
            "#{u.scheme.downcase}://api.photobucket.com#{(u.scheme.downcase == 'http' && u.port != 80) || (u.scheme.downcase == 'https' && u.port != 443) ? ":#{u.port}" : ""}#{(u.path && u.path != '') ? u.path : '/'}"
        end
    end
end

#patch to print out signature_base_string - just for debugging
#module OAuth::Signature::HMAC
    #class Base < OAuth::Signature::Base

        #private

        #def digest
            #puts ">>> " + signature_base_string
            #sig = self.class.digest_class.digest(secret, signature_base_string)
            #puts ">>>>>> " + Base64.encode64(sig).chomp.gsub(/\n/,'')
            #sig
        #end
    #end
#end

#set up the generic consumer
chars = ("a".."z").to_a + ("1".."9").to_a
newpass = Array.new(31, '').collect{chars[rand(chars.size)]}.join
@consumer = OAuth::Consumer.new(API_KEY,

                             API_KEY_PRIVATE,

                             {

:site => "http://api.photobucket.com/",
:scheme => :header,
#:request_token_path => '/login/request',
:authorize_path => '/apilogin/login'
#:access_token_path => '/login/access',
#:oauth_timestamp => Time.now,
#:oauth_nonce => newpass,


})
#set up an empty access token because its easier
@access = OAuth::AccessToken.new(@consumer, '', '')

#do a login direct
@resp = @access.post("/time")
#@accessresp = JSON.parse(@resp.body)['content']
#todo catch errors here before parsing content, probably
print "111111111111111111.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0D11111111111111111111111111",@access
##pull out stuff from response
#@access.token = @accessresp['oauth_token']
#@access.secret = @accessresp['oauth_token_secret']
##reset the consumer url (yes, do it like this - must set site and url() resets the internal http object
#@consumer.options[:site] = "http://" + @accessresp['subdomain']
#@consumer.uri("http://" + @accessresp['subdomain'])
#username = @accessresp['username']
print "111111111111111111.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0D11111111111111111111111111",@resp.to_json


    @resp = @access.post("/login/direct/" + USERNAME,
                     { :password => USERNAME_PW, :format=>"json" }
                    )
@accessresp = JSON.parse(@resp.body)['content']


#as a test, lets get the current user logged in
#@resp = @access.get("/user?format=json")
#
#print JSON.parse(@resp.body)
##create an album
#probably want to test to see if it exists first
@resp1 = @access.post("/album/" + USERNAME,
                     {:format=>"json", :name=>'rubytest1'})
                   print "22222222222222222222222222222222222222222222222",@resp1
#print JSON.parse(@resp.body).to_yaml

#upload a url to the album
@resp = @access.post("/album/" + OAuth::Helper::escape(USERNAME + '/rubytest1') + '/upload',
                    {:format=>"json", :type=>'url', :imageUrl=>'http://www.google.com/intl/en_ALL/images/logo.gif'})
print  JSON.parse(@resp.body)