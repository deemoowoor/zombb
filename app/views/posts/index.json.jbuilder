json.array!(@posts) do |post|
  json.extract! post, :id, :title, :body, :created_at, :updated_at
  json.post_comments post.post_comments do |comment|
      json.extract! comment, :id, :user_id, :created_at, :updated_at
  end
  #json.url post_url(post, format: :json)
end
