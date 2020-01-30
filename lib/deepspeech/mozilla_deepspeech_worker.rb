# frozen_string_literal: true

require 'faktory_worker_ruby'
require 'connection_pool'
require 'securerandom'
require 'faktory'
require 'json'
require 'sqlite3'
require 'speech_to_text'
require 'yaml'

rails_environment_path = File.expand_path(
  File.join(__dir__, '..', '..', 'config', 'environment')
)
require rails_environment_path

module MozillaDeepspeech
  class TranscriptWorker # rubocop:disable Style/Documentation
    include Faktory::Job
    faktory_options retry: 2, concurrency: 5

    def perform(job_id) # rubocop:disable Metrics/MethodLength
      status = 'inProgress'
      update_status(job_id, status)
      props = YAML.load_file('settings.yaml')
      model_path = props['model_path']
      puts model_path
      filepath = "#{Rails.root}/storage/#{job_id}"
      
      #SpeechToText::MozillaDeepspeechS2T.generate_transcript(
      #  "#{filepath}/audio.wav",
      #  "#{filepath}/audio.json",
      #  model_path
      #)

      generate_transcript("#{filepath}/audio.wav",
                          "#{filepath}/audio.json",
                          model_path)

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

    def generate_transcript(audio, json_file, model_path)
      #deepspeech_command = "#{model_path}/deepspeech --model #{model_path}/models/output_graph.pbmm --alphabet #{model_path}/models/alphabet.txt --lm #{model_path}/models/lm.binary --trie #{model_path}/models/trie -e --audio #{audio} > #{json_file}"
      deepspeech_command = "deepspeech --json --model #{model_path}/deepspeech-0.6.1-models/output_graph.pbmm --lm #{model_path}/deepspeech-0.6.1-models/lm.binary --trie #{model_path}/deepspeech-0.6.1-models/trie --audio #{audio} > #{json_file}"
      Open3.popen2e(deepspeech_command) do |stdin, stdout_err, wait_thr|
        while line = stdout_err.gets
          puts "#{line}"
        end

        exit_status = wait_thr.value
        unless exit_status.success?
          puts '---------------------'
          puts "FAILED to execute --> #{deepspeech_command}"
          puts '---------------------'
        end
      end

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
