json.extract! jobstatus, :id, :jobID, :status, :created_at, :updated_at
json.url jobstatus_url(jobstatus, format: :json)
