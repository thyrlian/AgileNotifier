require 'json'
require 'httparty'

module AgileNotifier
  class ResponseError < StandardError
  end

  module ResponseHelper
    def get_value_of_key(key, *args)
      pm = PrivateMethods.new
      pm.get_value_of_key_from_json(key, pm.request_json_response(*args))
    end

    class PrivateMethods
      def request_json_response(*args)
        method = ((args[1].respond_to?(:delete) ? args[1].delete(:method) : false) || :get).to_sym
        supported_methods = [:get, :post, :put, :delete, :head, :options]
        unless supported_methods.include?(method)
          raise(RuntimeError, "Unsupported HTTP Method: #{method.to_s}", caller)
        else
          response = HTTParty.send(method, *args)
          if response.code.to_s.match(/^2\d{2}$/)
            return JSON.parse(response.body)
          else
            raise(ResponseError, "HTTP Status Code: #{response.code} - #{response.parsed_response}", caller)
          end
        end
      end

      def get_value_of_key_from_json(key, collection) # only returns the first match if duplicated keys exist
        if collection.respond_to?(:each_pair) # behaves like Hash
          return collection[key] if collection.has_key?(key)
          collection.keys.each do |k|
            value = send(__method__, key, collection[k]) # recursive call
            return value if !value.nil?
          end
        elsif collection.respond_to?(:each_index) # behaves like Array
          collection.each do |x|
            value = send(__method__, key, x) # recursive call
            return value if !value.nil?
          end
        end
        return nil
      end
    end
  end
end
