require_relative 'its'

module AgileNotifier
  class Jira < ITS
    alias_method :original_is_available?, :is_available?

    API_VERSION_URL = '/rest/api/latest/'

    def initialize(url)
      @url = url.gsub(/\/$/, '') + API_VERSION_URL
    end

    def is_available?
      original_is_available?(@url + 'serverInfo')
    end

  end
end