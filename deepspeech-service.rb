require './lib/deepspeech.rb'

if ENV['REDIS_URL'].nil?
  redis = Redis.new
else
  redis = Redis.new(url: ENV['REDIS_URL'])
end

loop do
#for i in 1..num_entries do
  #list, element = redis.blpop(RECORDINGS_JOB_LIST_KEY)
  #TextTrack.logger.info("Processing analytics for recording #{element}")
  #job_entry = JSON.parse(element)
  #puts job_entry
  CreateJobWorker.perform_async()
end
