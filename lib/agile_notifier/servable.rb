require 'net/http'

module AgileNotifier
  module Servable
    def is_https_request?(url)
      regex = /https:\/\//
      regex.match(url) ? true : false
    end

    def is_http_server_available?(url)
      uri = URI(url)
      begin
        res = Net::HTTP.get_response(uri)
      rescue Errno::ECONNREFUSED # server shutdown
        return false
      end
      return is_response_ok?(res)
    end

    def is_https_server_available?(url)
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Get.new(uri.request_uri)
      begin
        res = http.request(req)
      rescue
        return false
      end
      return is_response_ok?(res)
    end

    def is_response_ok?(res)
      status_code = res.code.to_i
      if status_code == 200
        return true
      else # e.g. 503 (Service Unavailable)
        return false
      end
    end

    def is_available?(url)
      if !is_https_request?(url)
        return is_http_server_available?(url)
      else
        return is_https_server_available?(url)
      end
    end
  end
end