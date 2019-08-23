require 'securerandom'
require 'json'
require 'speech_to_text'

class AudioToJsonController < ApplicationController


  def create_job
    audio = params[:file]
    @jobID = jobID = generate_jobID
    File.open("#{Rails.root}/storage/#{jobID}/audio.wav","wb") do |file|
      file.write audio.read
    end
      Thread.new{generate_words(jobID)}
    render :json=>@jobID
  end

  def check_status
    jobID = params[:jobID]
    #database query to get status
    db =  SQLite3::Database.open "db/development.sqlite3"
    status = db.get_first_row "select status from jobstatuses where jobID= #{jobID}"
    db.close
    return status
  end


  def transcript
    jobID = params[:jobID]
    if File.exist?("#{Rails.root}/storage/#{jobID}/audio.json")
      file = File.open("#{Rails.root}/storage/#{jobID}/audio.json")
      data = JSON.load file
      #render json:{"respose" : "#{data}"}
      render :json=>data
    else
      msg = "Can't Load the Json File"
      render :json=>msg
    end
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
    deepspeech_command = "#{model_path}/deepspeech --model #{model_path}/models/output_graph.pbmm --alphabet #{model_path}/models/alphabet.txt --lm #{model_path}/models/lm.binary --trie #{model_path}/models/trie -e --audio #{filepath}/audio.wav > #{filepath}/audio.json"
    system("#{deepspeech_command}")
    #update_status(jobID)
  end

  def update_status(jobID)
    File.exist?("#{Rails.root}/storage/#{jobID}/audio.json")
      #read File.
      #read(#words[] exist?)
      file = File.open("#{Rails.root}/storage/#{jobID}/audio.json")
      data = JSON.load file
      if (data["words"][0] == null){
        puts "Error in Json File"
      }
    else{

      db =  SQLite3::Database.open "db/development.sqlite3"
      status = db.get_first_row "INSERT INTO jobstatuses [(status)] VALUE ("Completed") where jobID= #{jobID}"
      db.close
    }

    end


  end
