json.extract! @post, :id, :title, :created_at, :updated_at
unless @edit
    json.body @markdown.render(@post.body)
    json.post_comments @post.post_comments do |comment|
        json.extract! comment, :id
        json.user comment.user
        json.text @markdown.render(comment.text)
    end
else
    json.body @post.body
end
