require_relative 'its'
require_relative 'response_helper'

module AgileNotifier
  class Jira < ITS
    extend ResponseHelper

    alias_method :original_is_available?, :is_available?

    API_VERSION_URL = '/rest/api/latest/'
    USERAGENT = 'AgileNotifier'

    def initialize(url, username, password)
      @url = url.gsub(/\/$/, '') + API_VERSION_URL
      @username, @password = username, password
    end

    def is_available?
      original_is_available?(@url + 'serverInfo')
    end

    class << self
      def get_value(key, url)
        get_value_of_key(key, url, :headers => {'Content-Type' => 'application/json', 'User-Agent' => USERAGENT}, :basic_auth => {:username => @username, :password => @password})
      end
    end

  end
end