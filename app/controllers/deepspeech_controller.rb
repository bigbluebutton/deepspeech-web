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
  end

  def check_status # rubocop:disable Metrics/MethodLength
    job_id = params[:job_id]
    if job_id.nil?
      data = '{"message" : "job_id not found"}'
      render json: data
      return
    end
    db = SQLite3::Database.open 'db/development.sqlite3'
    query = "select status from job_statuses where jobID = '#{job_id}'"
    status = db.get_first_row query
    db.close
    if status.nil?
      data = '{"message" : "No job_id found"}'
      render json: data
      return
    end
    data = "{\"status\" : \"#{status[0]}\"}"
    render json: data
  end

  def transcript # rubocop:disable Metrics/MethodLength
    job_id = params[:job_id]
    if job_id.nil?
      data = '{"message" : "job_id is nil"}'
      render json: data
      return
    end
    data = '{"message" : "File not found. Please check if job_id is correct and make sure status is completed"}'
    if File.exist?("#{Rails.root}/storage/#{job_id}/audio.json")
      file = File.open("#{Rails.root}/storage/#{job_id}/audio.json")
      data = JSON.load file
    end
    render json: data
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
    status = 'pending'
    db = SQLite3::Database.open 'db/development.sqlite3'
    query = "INSERT INTO job_statuses (jobID, status, created_at, updated_at) VALUES ('#{job_id}', '#{status}', '#{Time.now}', '#{Time.now}')"
    db.execute(query)
    db.close
  end
end
# rubocop:enable Style/Documentation
