json.extract! event, :id, :name, :description, :start_date, :end_date, :city, :private, :distance, :created_at, :updated_at, :user_id, :is_register, :liked_by
json.url event_url(event, format: :json)
