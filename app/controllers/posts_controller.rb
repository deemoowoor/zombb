class PostsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_post, except: [:create, :index, :new]

    before_action :editor_or_admin, only: [:new, :create]
    before_action :owner_or_admin, only: [:edit, :update, :destroy]
    before_action :prepare_markdown, only: [:show, :edit, :update, :create]

    # GET /posts
    # GET /posts.json
    def index
        @posts = Post.all
    end

    # GET /posts/1
    # GET /posts/1.json
    def show
        @edit = params[:edit]
    end

    # GET /posts/new
    def new
        @post = Post.new
    end

    # GET /posts/1/edit
    def edit
    end

    # POST /posts
    # POST /posts.json
    def create
        @post = Post.new(post_params)
        @post.user = current_user
        create_object @post, post_params, 'Post'
    end

    # PATCH/PUT /posts/1
    # PATCH/PUT /posts/1.json
    def update
        update_object @post, post_params, 'Post'
    end

    # DELETE /posts/1
    # DELETE /posts/1.json
    def destroy
        @post.destroy
        respond_to do |format|
            format.html { redirect_to posts_url }
            format.json { head :no_content }
        end
    end

    private

    def set_post
        @post = Post.find(params[:id])
        @user = @post.user
    end

    def prepare_markdown
        @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
        params.require(:post).permit(:title, :body)
    end
end
