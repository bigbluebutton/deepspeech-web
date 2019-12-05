# rubocop:disable Style/Documentation
# frozen_string_literal: true
class DeepspeechController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def home
    data = { message: 'hello' }
    # rubocop:disable Style/GlobalVars
    $redis.lpush('create_job', data.to_json)
    # rubocop:enable Style/GlobalVars
  end

  def create_job # rubocop:disable Metrics/MethodLength
    props = YAML.load_file('credentials.yaml')
    api_key = props['api_key']
    param_key = params[:api_key]
    
    if api_key == param_key
      audio = params[:file]

      if audio.nil?
        data = '{"message" : "file not found"}'
        render json: data
        return
      end
      job_id = generate_job_id
      File.open("#{Rails.root}/storage/#{job_id}/audio.wav", 'wb') do |file|
        file.write audio.read
      end
      set_status(job_id)
      data = { 'job_id' => job_id }
      render json: data
      # rubocop:disable Style/GlobalVars
      $redis.lpush('transcript', data.to_json)
      # rubocop:enable Style/GlobalVars
    else
      data = '{"message" : "incorrect api_key"}'
      render json: data
    end
  end

  def check_status # rubocop:disable Metrics/MethodLength
    props = YAML.load_file('credentials.yaml')
    api_key = props['api_key']
    param_key = params[:api_key]
    
    if api_key == param_key
      job_id = params[:job_id]
      if job_id.nil?
        data = '{"message" : "job_id not found"}'
        render json: data
        return
      end
      job = JobStatus.find_by(job_id: job_id)
      if job.nil?
        data = '{"message" : "No job found"}'
        render json: data
        return
      end
      data = "{\"status\" : \"#{job.status}\"}"
      render json: data
    else
      data = '{"message" : "incorrect api_key"}'
      render json: data
    end
  end

  def transcript # rubocop:disable Metrics/MethodLength
    props = YAML.load_file('credentials.yaml')
    api_key = props['api_key']
    param_key = params[:api_key]
    
    if api_key == param_key
      job_id = params[:job_id]
      if job_id.nil?
        data = '{"message" : "job_id is nil"}'
        render json: data
        return
      end
      data = '{"message" : "File not found. Please check job_id and status"}'
      if File.exist?("#{Rails.root}/storage/#{job_id}/audio.json")
        file = File.open("#{Rails.root}/storage/#{job_id}/audio.json")
        data = JSON.load file
      end
      render json: data
      
      if Dir.exist?("#{Rails.root}/storage/#{job_id}")
          system("rm -r #{Rails.root}/storage/#{job_id}")
      end
    else
      data = '{"message" : "incorrect api_key"}'
      render json: data
    end  
  end

  private

  def generate_job_id
    job_id = SecureRandom.hex(10)
    time = (Time.now.to_f * 1000).to_i
    job_id += "_#{time}"
    Dir.chdir "#{Rails.root}/storage"
    system("mkdir #{job_id}")
    Dir.chdir Rails.root.to_s
    job_id
  end

  def set_status(job_id) # rubocop:disable Naming/AccessorMethodName
    job = JobStatus.new
    job.job_id = job_id
    job.status = 'pending'
    job.created_at = Time.now
    job.updated_at = Time.now
    job.save
  end
end
# rubocop:enable Style/Documentation
