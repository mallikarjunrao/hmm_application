#!/usr/bin/ruby -w

NAMESPACE = 'urn:ruby:calculation'
URL = 'http://localhost:3000/'

begin
   driver = SOAP::RPC::Driver.new(URL, NAMESPACE)

   # Add remote sevice methods
   driver.add_method('add', 'a', 'b')

   # Call remote service methods
   puts driver.add(20, 30)
rescue => err
   puts err.message
end
