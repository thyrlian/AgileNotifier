require 'json'
require 'httparty'
require_relative 'scm'
require_relative 'response_helper'

module AgileNotifier
  class Github < SCM
    extend ResponseHelper

    ENTERPRISE_API = '/api/v3'
    USERAGENT = 'AgileNotifier'

    def initialize(url)
      super
      if url.include?(ENTERPRISE_API)
        status_url = url + '/zen'
        begin
          status = HTTParty.get(status_url).code
          availability = ( status == 200 )
        rescue => e
          puts e.message
          availability = false
        end
      else
        status_url = url.gsub(/:\/\/api\./, '://status.') + '/api/status.json'
        status = self.class.get_value('status', status_url)
        availability = ( status == 'good' )
      end
      raise('Github is not available.') unless availability
    end

    class << self
      def new_enterprise_version(url)
        new(url + ENTERPRISE_API)
      end

      def get_value(key, url)
        get_value_of_key(key, url, :headers => {'User-Agent' => USERAGENT})
      end
    end

    def add_repository(args)
      user = args[:user]
      repo = args[:repo]
      repository = Repository.new(user: user, repo: repo, url: @url)
      @repositories.push(repository)
    end

    class Repository < SCM::Repository
      def get_committer_name_of_a_commit(revision)
        url = @url + "/repos/#{@user}/#{@repo}/git/commits/#{revision}"
        committer = Github.get_value('committer', url)
        committer['name']
      end
    end
  end
end
