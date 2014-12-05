json.array!(@post_comments) do |post_comment|
  json.extract! post_comment, :id, :text, :timestamp
  json.url post_post_comments_url(@post, post_comment, format: :json)
end
