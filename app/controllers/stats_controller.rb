class StatsController < ApplicationController
    before_action :authenticate_user!
    before_action :admin_only

    def index
        @stats = {
            users: User.find(:all).count,
            posts: Post.find(:all).count,
            comments: PostComment.find(:all).count,
        }
    end
end
