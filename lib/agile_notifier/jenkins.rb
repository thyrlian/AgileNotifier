require_relative 'ci'
require 'json'
require 'httparty'

module AgileNotifier
  class Jenkins < CI
    JSON_API = '/api/json'

    def self.get_node(url, node_name)
      response = HTTParty.get(url + JSON_API)
      if response.code == 200
        return JSON.parse(response.body)[node_name]
      else
        return nil
      end
    end

    def get_all_jobs
      jobs = self.class.get_node(@url, 'jobs')
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
        last_build = Jenkins.get_node(@url, 'lastBuild')
        last_build.nil? ? nil : Build.new(last_build['number'], last_build['url'])
      end

      class Build < CI::Job::Build
        def get_result
          result = Jenkins.get_node(@url, 'result')
          result.nil? ? nil : result
        end
      end
    end
  end
end