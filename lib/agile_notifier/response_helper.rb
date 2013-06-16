require 'json'
require 'httparty'

module AgileNotifier
  class ResponseError < StandardError
  end

  module ResponseHelper
    def get_value_of_key(key, *args)
      pm = PrivateMethods.new
      pm.get_value_of_key_from_json(key, pm.get_json_response(*args))
    end

    class PrivateMethods
      def get_json_response(*args)
        response = HTTParty.get(*args)
        if response.code == 200
          return JSON.parse(response.body)
        else
          raise(ResponseError, "HTTP Status Code: #{response.code} - #{response.parsed_response}", caller[1])
        end
      end

      def get_value_of_key_from_json(key, json_response_body)
        json_response_body[key]
      end
    end
  end
end