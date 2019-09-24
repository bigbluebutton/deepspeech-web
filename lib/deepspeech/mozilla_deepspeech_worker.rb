# frozen_string_literal: true

require 'faktory_worker_ruby'
require 'connection_pool'
require 'securerandom'
require 'faktory'
require 'json'
require 'sqlite3'
require 'speech_to_text'

rails_environment_path = File.expand_path(
  File.join(__dir__, '..', '..', 'config', 'environment')
)
require rails_environment_path

module MozillaDeepspeech
  class TranscriptWorker # rubocop:disable Style/Documentation
    include Faktory::Job
    faktory_options retry: 2

    def perform(job_id) # rubocop:disable Metrics/MethodLength
      status = 'inProgress'
      update_status(job_id, status)
      model_path = '/home/deepspeech/temp'
      filepath = "#{Rails.root}/storage/#{job_id}"
      puts "start transcript for #{job_id}"
      SpeechToText::MozillaDeepspeechS2T.generate_transcript(
        "#{filepath}/audio.wav",
        "#{filepath}/audio.json",
        model_path
      )

      if File.exist?("#{Rails.root}/storage/#{job_id}/audio.json")
        file = File.open("#{Rails.root}/storage/#{job_id}/audio.json", 'r')
        data = JSON.load file
        status = if data['words'].nil?
                   'failed'
                 else
                   'completed'
                 end
      else
        status = 'failed'
      end
      update_status(job_id, status)
    end

    def update_status(job_id, status)
      ActiveRecord::Base.connection_pool.with_connection do
        job = JobStatus.find_by(job_id: job_id)
        job.status = status
        job.updated_at = Time.now
        job.save
      end
    end
  end
end
