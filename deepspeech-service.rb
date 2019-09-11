# frozen_string_literal: true

require './lib/deepspeech'

props = YAML.load_file('settings.yaml')

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
