require 'net/http'
require 'json'
require 'uri'

Puppet::Functions.create_function(:'namikoda::ipv6sfor') do
  def ipv6sfor(key)
    url = "https://api.namikoda.com/v1/public/ipsfor/#{key}" 
    uri = URI.parse(url)

    req = Net::HTTP::Get.new(uri.request_uri)
    begin
      if @@namikoda_apikey.to_s.empty?
        raise "namikoda::ipv6sfor missing namikoda_apikey. Be sure to call namikoda::set_apikey() before this function."
      end
    rescue NameError => e
        raise "namikoda::ipv6sfor missing namikoda_apikey. Be sure to call namikoda::set_apikey() before this function."
    end
    req['X-Namikoda-Key'] = @@namikoda_apikey
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.request(req)

    begin
      res = http.request(req)
      unless res.code.match(/^2/)
        # Log some woe
        raise "api.namikoda.com replied with error: " + res.body
      end
      begin
        resobj = JSON.parse(res.body)
        return resobj['ipv6s']
      rescue JSON::ParserError 
        raise "api.namikoda.com replied with invalid json: " + res.body
      end
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
           Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      raise "api.namikoda.com did not respond: " + e
    end

  end
end
