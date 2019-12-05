# frozen_string_literal: true

Rails.application.routes.draw do
  resources :jobstatuses
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'deepspeech/home', to: 'deepspeech#home'
  post 'deepspeech/createjob/:api_key', to: 'deepspeech#create_job'
  post 'deepspeech/checkstatus/:job_id/:api_key', to: 'deepspeech#check_status'
  post 'deepspeech/transcript/:job_id/:api_key', to: 'deepspeech#transcript'
end
