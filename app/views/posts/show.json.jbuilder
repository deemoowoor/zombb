json.extract! @post, :id, :title, :created_at, :updated_at

if @post.user
    json.user @post.user, :id, :name, :email, :role
else
    json.user nil
end

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
