require 'securerandom'
require 'json'
require 'sqlite3'
require 'speech_to_text'

class DeepspeechController < ApplicationController

  def create_job
    audio = params[:file]
    if audio.nil?
      data = "{\"message\" : \"file not found\"}"
      render :json=>data
      return
    end
    jobID = generate_jobID
    File.open("#{Rails.root}/storage/#{jobID}/audio.wav","wb") do |file|
      file.write audio.read
    end
      update_status(jobID,"inProgress")
      Thread.new{generate_words(jobID)}
      data = "{\"jobID\" : \"#{jobID}\"}"
    render :json=>data
  end

  def check_status
    jobID = params[:jobID]
    if jobID.nil?
      data = "{\"message\" : \"jobID not found\"}"
      render :json=>data
      return
    end
    db =  SQLite3::Database.open "db/development.sqlite3"
    status = db.get_first_row "select status from job_statuses where jobID = '#{jobID}'"
    db.close
    data = "{\"status\" : \"#{status[0]}\"}"
    render :json=>data
  end

  def transcript
    jobID = params[:jobID]
    if jobID.nil?
      data = "{\"message\" : \"jobID not found\"}"
      render :json=>data
      return
    end
    data = "{\"message\" : \"File not found. Make sure status is completed\"}"
    if File.exist?("#{Rails.root}/storage/#{jobID}/audio.json")
      file = File.open("#{Rails.root}/storage/#{jobID}/audio.json")
      data = JSON.load file
    end
    render :json=>data
  end

  private
  def generate_jobID
    jobID = SecureRandom.hex(10)
    Dir.chdir "#{Rails.root}/storage"
    system("mkdir #{jobID}")
    Dir.chdir "#{Rails.root}"
    return jobID
  end

  def generate_words(jobID)
    model_path = "/home/ari/workspace/temp"
    filepath = "#{Rails.root}/storage/#{jobID}"
    SpeechToText::MozillaDeepspeechS2T.generate_transcript("#{filepath}/audio.wav","#{filepath}/audio.json",model_path)
    update_status(jobID,"completed")
  end

  def update_status(jobID,status)
    db = SQLite3::Database.open "db/development.sqlite3"
    if status == "inProgress"
      query = "INSERT INTO job_statuses (jobID, status, created_at, updated_at) VALUES ('#{jobID}', '#{status}', '#{Time.now}', '#{Time.now}')"
      db.execute(query)
    elsif status == "completed"
        if File.exist?("#{Rails.root}/storage/#{jobID}/audio.json")
          file = File.open("#{Rails.root}/storage/#{jobID}/audio.json","r")
          data = JSON.load file
          if data["words"].nil?
            status = "failed"
          end
        else
          status = "failed"
        end
        query = "update job_statuses set status = '#{status}', updated_at = '#{Time.now}' where jobID = '#{jobID}'"
        db.execute(query)
    else
      puts "something went wrong in update status.."
    end
    db.close
    end
  end
