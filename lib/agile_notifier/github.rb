require 'json'
require 'httparty'
require_relative 'scm'
require_relative 'response_helper'

module AgileNotifier
  class Github < SCM
    extend ResponseHelper

    ENTERPRISE_API = '/api/v3'
    USERAGENT = 'AgileNotifier'
    
    @@headers = {:headers => {'User-Agent' => USERAGENT}}
    @@auth = nil

    def initialize(url, args = {})
      super
      @@auth = args.fetch(:basic_auth, nil)
      if url.include?(ENTERPRISE_API)
        status_url = url + '/zen'
        begin
          args = [status_url]
          args.push({:basic_auth => @@auth}) if @@auth
          status = HTTParty.get(*args).code
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
      def new_enterprise_version(url, args = {})
        new(url + ENTERPRISE_API, args)
      end

      def get_value(key, url)
        args = @@headers
        args.merge!({:basic_auth => @@auth}) if @@auth
        get_value_of_key(key, url, args)
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
