class PostComment < ActiveRecord::Base
    belongs_to :user
    belongs_to :post
    has_many :post_comments
end
