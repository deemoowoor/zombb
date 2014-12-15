class StatsController < ApplicationController
    before_action :authenticate_user!
    before_action :admin_only

    def index
        @stats = {
            users: User.all.count,
            posts: Post.all.count,
            comments: PostComment.all.count,
        }
    end
end
