require_relative 'scm'
require_relative 'response_helper'
require 'json'
require 'httparty'

module AgileNotifier
  class Github < SCM
    extend ResponseHelper

    ENTERPRISE_API = '/api/v3'
    USERAGENT = 'AgileNotifier'

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