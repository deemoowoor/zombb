json.extract! @post, :id, :title, :user, :created_at, :updated_at

unless @edit
    json.body @markdown.render(@post.body)
    json.post_comments @post.post_comments do |comment|
        json.extract! comment, :id
        json.user comment.user, :name, :email, :role
        json.text @markdown.render(comment.text)
    end
else
    json.body @post.body
end
