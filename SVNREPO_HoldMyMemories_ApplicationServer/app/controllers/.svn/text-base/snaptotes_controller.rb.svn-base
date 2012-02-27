class SnaptotesController < ApplicationController
  require 'savon'
  layout false  

  def send_request_test_dev
    #    client = Savon::Client.new "http://xml.dev.snaptotes.com/CreateOrderWeb.asmx?WSDL"
    #    response = client.submit_order_test do |soap|
    #      soap.body = '<order xmlns="SnaptotesXML">
    #      <partnerid>2855</partnerid>
    #      <orderdate>7/21/07</orderdate>
    #      <orderid>5555346</orderid>
    #      <giftnote>Test XML Post Order</giftnote>
    #      <shippinginfo>
    #        <specialinstructions>Please ship by Sept. 24 2007</specialinstructions>
    #        <firstname>John</firstname>
    #        <lastname>Smith</lastname>
    #        <address1>555 Eastwood Ave.</address1>
    #        <address2></address2>
    #        <city>Durham</city>
    #        <state>NC</state>
    #        <zip>27603</zip>
    #        <country>US</country>
    #        <phone>555-555-5555</phone>
    #        <email>jsmith@jsmith.com</email>
    #        <shippingmethod>TD</shippingmethod>
    #      </shippinginfo>
    #      <orderitems>
    #        <Item productid="0015MB1N">
    #          <images>
    #            <Image url="http://www.snaptotes.com/1.jpg" />
    #          </images>
    #          <quantity>1</quantity>
    #          <name>Everyday Bag Leather Green Two Side No Collage</name>
    #        </Item>
    #        <Item productid="0010MB1N">
    #          <images>
    #            <Image url="http://www.snaptotes.com/1.jpg" />
    #          </images>
    #          <quantity>1</quantity>
    #          <name>Bucket Bag Micro Black One Side No Collage</name>
    #        </Item>
    #      </orderitems>
    #    </order>'
    #    end
    #    render :xml => response
  end


  def send_request
    client = Savon::Client.new "http://xml.dev.snaptotes.com/CreateOrderWeb.asmx?WSDL"
    response = client.submit_order do |soap|
      soap.body = '<order xmlns="SnaptotesXML">
      <partnerid>24270</partnerid>
      <orderdate>7/21/07</orderdate>
      <orderid>5555346</orderid>
      <giftnote>Test XML Post Order</giftnote>
      <shippinginfo>
        <specialinstructions>Please ship by Sept. 24 2007</specialinstructions>
        <firstname>John</firstname>
        <lastname>Smith</lastname>
        <address1>555 Eastwood Ave.</address1>
        <address2></address2>
        <city>Durham</city>

        <state>NC</state>
        <zip>27603</zip>
        <country>US</country>
        <phone>555-555-5555</phone>
        <email>jsmith@jsmith.com</email>
        <shippingmethod>33</shippingmethod>

      </shippinginfo>
      <orderitems>
        <Item productid="0015MB1N">
          <images>
            <Image url="http://holdmymemories.com/images/common/logo_trans.png" />
          </images>
          <quantity>1</quantity>
          <name>Everyday Bag Leather Green Two Side No Collage</name>

        </Item>
        <Item productid="0010MB1N">
          <images>
            <Image url="http://holdmymemories.com/images/common/logo_trans.png" />
          </images>
          <quantity>1</quantity>
          <name>Bucket Bag Micro Black One Side No Collage</name>
        </Item>

      </orderitems>
    </order>'
    end
    render :xml => response
  end

  def send_request_ruby
    require 'soap/wsdlDriver'
    require 'pp'
    wsdl = 'http://xml.snaptotes.com/CreateOrderWeb.asmx?WSDL'
    driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver

    # Log SOAP request and response
    driver.wiredump_file_base = "soap-log.txt"

    response =  driver.SubmitOrder('<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <soap:Body>
    <order xmlns="SnaptotesXML">
      <partnerid>24270</partnerid>
      <orderdate>7/21/07</orderdate>
      <orderid>5555346</orderid>
      <giftnote>Test XML Post Order</giftnote>

      <shippinginfo>
        <specialinstructions>Please ship by Sept. 24 2007</specialinstructions>
        <firstname>John</firstname>
        <lastname>Smith</lastname>
        <address1>555 Eastwood Ave.</address1>
        <address2></address2>
        <city>Durham</city>

        <state>NC</state>
        <zip>27603</zip>
        <country>US</country>
        <phone>555-555-5555</phone>
        <email>jsmith@jsmith.com</email>
        <shippingmethod>33</shippingmethod>

      </shippinginfo>
      <orderitems>
        <Item productid="0015MB1N">
          <images>
            <Image url="http://www.snaptotes.com/1.jpg" />
          </images>
          <quantity>1</quantity>
          <name>Everyday Bag Leather Green Two Side No Collage</name>

        </Item>
        <Item productid="0010MB1N">
          <images>
            <Image url="http://www.snaptotes.com/1.jpg" />
          </images>
          <quantity>1</quantity>
          <name>Bucket Bag Micro Black One Side No Collage</name>
        </Item>

      </orderitems>
    </order>
  </soap:Body>
</soap:Envelope>')
    #pp(response)
    render :xml => response.SubmitOrderResult
  end

  def submit_order_soap
    require 'net/http'
    require 'net/https'

    # Create te http object
    http = Net::HTTP.new('http://xml.snaptotes.com/CreateOrderWeb.asmx?WSDL', 80)
    http.use_ssl = false
    path = "SnaptotesXML/SubmitOrder"


    # Create the SOAP Envelope
    data = <<-EOF
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <soap:Body>
    <order xmlns="SnaptotesXML">
      <partnerid>24270</partnerid>
      <orderdate>7/21/07</orderdate>
      <orderid>5555346</orderid>
      <giftnote>Test XML Post Order</giftnote>

      <shippinginfo>
        <specialinstructions>Please ship by Sept. 24 2007</specialinstructions>
        <firstname>John</firstname>
        <lastname>Smith</lastname>
        <address1>555 Eastwood Ave.</address1>
        <address2></address2>
        <city>Durham</city>

        <state>NC</state>
        <zip>27603</zip>
        <country>US</country>
        <phone>555-555-5555</phone>
        <email>jsmith@jsmith.com</email>
        <shippingmethod>33</shippingmethod>

      </shippinginfo>
      <orderitems>
        <Item productid="0015MB1N">
          <images>
            <Image url="http://www.snaptotes.com/1.jpg" />
          </images>
          <quantity>1</quantity>
          <name>Everyday Bag Leather Green Two Side No Collage</name>

        </Item>
        <Item productid="0010MB1N">
          <images>
            <Image url="http://www.snaptotes.com/1.jpg" />
          </images>
          <quantity>1</quantity>
          <name>Bucket Bag Micro Black One Side No Collage</name>
        </Item>

      </orderitems>
    </order>
  </soap:Body>
</soap:Envelope>
    EOF

    # Set Headers
    headers = {
      'Referer' => 'http://www.holdmymemories.com',
      'Content-Type' => 'text/xml',
      'Host' => 'holdmymemories.com'
    }

    # Post the request
    resp, data = http.post(path, data, headers)

    # Output the results
    puts 'Code = ' + resp.code
    puts 'Message = ' + resp.message
    resp.each { |key, val| puts key + ' = ' + val }
    render :text => data
  end
end
