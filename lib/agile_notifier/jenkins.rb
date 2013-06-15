require_relative 'ci'
require_relative 'response_helper'
require 'json'
require 'httparty'

module AgileNotifier
  class Jenkins < CI
    extend ResponseHelper
    JSON_API = '/api/json'

    def self.get_value(url, key)
      get_value_of_key(url + JSON_API, key)
    end

    def get_all_jobs
      jobs = self.class.get_value(@url, 'jobs')
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
        last_build = Jenkins.get_value(@url, 'lastBuild')
        last_build.nil? ? nil : Build.new(last_build['number'], last_build['url'])
      end

      class Build < CI::Job::Build
        def get_result
          result = Jenkins.get_value(@url, 'result')
          result.nil? ? nil : result
        end

        def get_revision
          scm_info = Jenkins.get_value(@url, 'actions')[2]
          scm_info.nil? ? nil : revision = scm_info['lastBuiltRevision']['SHA1']
        end
      end
    end
  end
end