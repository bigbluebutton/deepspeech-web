Rails.application.routes.draw do
  resources :jobstatuses
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    post 'deepspeech/createjob', to: "audio_to_json#create_job"
    get 'deepspeech/checkstatus/:jobID', to: 'audio_to_json#check_status'
    get 'deepspeech/transcript/:jobID', to: 'audio_to_json#transcript'
end
