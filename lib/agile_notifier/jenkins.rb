require_relative 'ci'
require_relative 'response_helper'
require 'json'
require 'httparty'

module AgileNotifier
  class Jenkins < CI
    extend ResponseHelper

    JSON_API = '/api/json'

    def self.get_value(key, url)
      get_value_of_key(key, url + JSON_API)
    end

    def initialize(url, *names)
      @url = url
      if names.empty?
        @jobs = get_all_jobs
      else
        @jobs = []
        names.each do |name|
          job_url = "#{@url}/job/#{name}/"
          @jobs.push(Job.new(name, job_url))
        end
      end
    end

    def get_all_jobs
      jobs = self.class.get_value('jobs', @url)
      if jobs.nil?
        return nil
      else
        jobs.inject([]) do |all_jobs, job|
          all_jobs.push(Job.new(job['name'], job['url']))
        end
      end
    end

    class Job < CI::Job
      def get_last_build
        last_build = Jenkins.get_value('lastBuild', @url)
        last_build.nil? ? nil : Build.new(last_build['number'], last_build['url'])
      end

      class Build < CI::Job::Build
        def get_result
          result = Jenkins.get_value('result', @url)
          result.nil? ? nil : result
        end

        def get_revision
          scm_info = Jenkins.get_value('actions', @url)[3]
          scm_info.nil? ? nil : revision = scm_info['lastBuiltRevision']['SHA1']
        end

        def passed?
          @result == 'SUCCESS'
        end

        def failed?
          @result == 'FAILURE'
        end
      end
    end
  end
end