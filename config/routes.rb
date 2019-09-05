Rails.application.routes.draw do
  resources :jobstatuses
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    get 'deepspeech/home', to: "deepspeech#home"
    post 'deepspeech/createjob', to: "deepspeech#create_job"
    get 'deepspeech/checkstatus/:jobID', to: 'deepspeech#check_status'
    get 'deepspeech/transcript/:jobID', to: 'deepspeech#transcript'
end
