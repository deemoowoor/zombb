json.array!(@posts) do |post|
    json.extract! post, :id, :title, :body, :created_at, :updated_at
    if post.user
        json.user post.user, :name, :email
    else
        json.user nil
    end
    json.post_comments post.post_comments do |comment|
        json.extract! comment, :id, :user_id, :created_at, :updated_at
    end
    #json.url post_url(post, format: :json)
end
