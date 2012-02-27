
  require "soap/rpc/standaloneserver"

begin
   class MyServerController < SOAP::RPC::StandaloneServer

      # Expose our services
      def initialize(*args)
         add_method(self, 'add', 'a', 'b')
         add_method(self, 'div', 'a', 'b')
      end

      # Handler methods
      def add(a, b)
         return a + b
      end
      def div(a, b)
         return a / b
      end
      def hello

        
      end
  end
  server = MyServer.new("MyServer",
            'urn:ruby:calculation', 'localhost', 3000)
  
  server.start
rescue => err
  puts err.message
end
