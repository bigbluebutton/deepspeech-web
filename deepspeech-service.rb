# frozen_string_literal: true

require './lib/deepspeech'
require 'connection_pool'
require 'sqlite3'
require 'yaml'


props = YAML.load_file('settings.yaml')

if props['deepspeech_version']=='cpu'
    
     redis = if ENV['REDIS_URL'].nil?
           Redis.new
         else
           Redis.new(url: ENV['REDIS_URL'])
         end

    JOB_KEY = props['redis_jobs_transcript']
    num_entries = redis.llen(JOB_KEY)
    puts "num_entries = #{num_entries}"

    loop do
      # for i in 1..num_entries do
      _job_list, data = redis.blpop(JOB_KEY)
      job_entry = JSON.parse(data)
      puts "job_entry...#{job_entry['job_id']}"
      MozillaDeepspeech::TranscriptWorker.perform_async(job_entry['job_id'])
    end
    
elsif props['deepspeech_version']=='gpu'

    #props = YAML.load_file('settings.yaml')  
      
#    redis = if ENV['REDIS_URL'].nil?
#      Redis.new
#    else
#      Redis.new(url: ENV['REDIS_URL'])
#    end
#
#    job_key = props['redis_jobs_transcript']
#    num_entries = redis.llen(job_key)
#    puts "num_entries = #{num_entries}"
    
    counter = 1
    loop do
        if counter == 1
            MozillaDeepspeech::SchedulerWorker.perform_async()
            counter = counter + 1
        end
    end

end

