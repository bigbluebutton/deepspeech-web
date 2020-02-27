# frozen_string_literal: true

require 'faktory_worker_ruby'
require 'connection_pool'
require 'faktory'
require 'speech_to_text'
require 'json'
require 'sqlite3'
require 'yaml'

rails_environment_path = File.expand_path(
  File.join(__dir__, '..', '..', 'config', 'environment')
)
require rails_environment_path

module MozillaDeepspeech
  class SchedulerWorker # rubocop:disable Style/Documentation
    include Faktory::Job
    faktory_options retry: 0, concurrency: 1

    def perform() # rubocop:disable Metrics/MethodLength
    
      props = YAML.load_file('settings.yaml')  
      
      redis = if ENV['REDIS_URL'].nil?
        Redis.new
      else
        Redis.new(url: ENV['REDIS_URL'])
      end

      job_key = props['redis_jobs_transcript']
      num_entries = redis.llen(job_key)
      puts "num_entries = #{num_entries}"
      
      # for i in 1..num_entries do
      _job_list, data = redis.blpop(job_key)
      job_entry = JSON.parse(data)
      puts "job_entry...#{job_entry['job_id']}"
      MozillaDeepspeech::TranscriptWorker.perform_async(job_entry['job_id'])
    end

  end
end
