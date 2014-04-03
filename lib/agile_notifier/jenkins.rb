require 'uri'
require 'json'
require 'httparty'
require_relative 'ci'
require_relative 'response_helper'

module AgileNotifier
  class Jenkins < CI
    extend ResponseHelper

    JSON_API = '/api/json'

    def self.get_value(key, url)
      get_value_of_key(key, url.gsub(/\/$/, '') + JSON_API)
    end

    def initialize(url, *names)
      @url = url
      if names.empty?
        @jobs = get_all_jobs
      else
        @jobs = []
        names.each do |name|
          job_url = URI.encode("#{@url}/job/#{name}/")
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

      def get_penultimate_build
        last_build.get_previous_build
      end

      class Build < CI::Job::Build
        include Servable

        def get_result
          result = Jenkins.get_value('result', @url)
          result.nil? ? nil : result
        end

        def get_revision
          revision = Jenkins.get_value('lastBuiltRevision', @url)
          revision.nil? ? nil : revision['SHA1']
        end

        def get_previous_build
          previous_number = @number - 1
          while previous_number > 0
            previous_url = @url.gsub(/\/#{@number}\//, "/#{previous_number}/")
            if is_available?(previous_url)
              return Build.new(previous_number, previous_url)
            else
              previous_number -= 1
            end
          end
          return nil
        end

        def get_previous_result
          previous_build = get_previous_build
          if previous_build
            return previous_build.get_result
          else
            return nil
          end
        end

        def passed?
          @result == 'SUCCESS'
        end

        def failed?
          @result == 'FAILURE'
        end

        def fixed?
          if get_previous_result == 'FAILURE'
            return passed?
          else
            return nil # if previous result is SUCCESS, doesn't make sense, then return nil
          end
        end
      end
    end
  end
end
