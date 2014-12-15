json.extract! @post_comment, :id, :user, :timestamp, :created_at, :updated_at
unless @edit
    json.text @markdown.render(@post_comment.text)
else
    json.text @post_comment.text
end
