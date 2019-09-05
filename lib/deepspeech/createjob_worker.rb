# encoding: UTF-8
require 'faktory_worker_ruby'
require 'connection_pool'
require 'securerandom'
require 'faktory'
rails_environment_path = File.expand_path(File.join(__dir__, '..', '..', 'config', 'environment'))
require rails_environment_path

  class CreateJobWorker
    include Faktory::Job
    faktory_options retry: 5

    def perform()
      puts "hello world"
    end
  end
