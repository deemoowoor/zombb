json.extract! @post, :id, :title, :user, :created_at, :updated_at

unless @edit
    json.body @markdown.render(@post.body)
    json.post_comments @post.post_comments do |comment|
        json.extract! comment, :id
        if comment.user
            json.user comment.user, :name, :email, :role
        else
            json.user nil
        end
        json.text @markdown.render(comment.text)
    end
else
    json.body @post.body
end
