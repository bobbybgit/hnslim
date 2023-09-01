json.extract! membership, :id, :user_id, :group_id, :admin, :created_at, :updated_at
json.url membership_url(membership, format: :json)
