require_relative 'its'
require_relative 'response_helper'

module AgileNotifier
  class Jira < ITS
    include ResponseHelper

    alias_method :original_is_available?, :is_available?

    API_VERSION_URL = '/rest/api/latest/'
    USERAGENT = 'AgileNotifier'

    def initialize(args)
      @url = args.fetch(:url).gsub(/\/$/, '') + API_VERSION_URL
      @username = args.fetch(:username)
      @password = args.fetch(:password)
      @wip = Hash.new
    end

    def is_available?
      original_is_available?(@url + 'serverInfo')
    end

    def query_amount_of_tickets(jql)
      get_value('total', jql)
    end

    def set_limit(project, query, limit)
      @wip[project] = {:query => query, :limit => limit}
    end

    def exceeds_limit?
      @wip.inject({}) do |result, (key, value)|
        result.merge({key => query_amount_of_tickets(value[:query]) > value[:limit]})
      end
    end

    def get_value(key, jql, max = 1)
      get_value_of_key(key,
                       @url + 'search',
                       :method => :post,
                       :headers => {'Content-Type' => 'application/json', 'User-Agent' => USERAGENT},
                       :basic_auth => {:username => @username, :password => @password},
                       :body => {'jql' => jql, 'maxResults' => max}.to_json)
    end

    private :get_value
  end
end