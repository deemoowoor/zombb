class PostCommentsController < ApplicationController
    before_action :authenticate_user!, except: [:show]
    before_action :set_post_and_comment, except: [:index, :create]
    before_action :owner_or_admin, only: [:edit, :update, :destroy]
    before_action :prepare_markdown, only: [:show, :edit, :update, :create]

    # GET /post_comments/1
    # GET /post_comments/1.json
    def show
        @edit = params[:edit]
    end

    # GET /post_comments/1/edit
    def edit
    end

    # POST /post_comments
    # POST /post_comments.json
    def create
        @post = Post.find(params[:post_id])
        @post_comment = PostComment.new(post_comment_params)
        @post_comment.post = @post
        @post_comment.user = current_user

        respond_to do |format|
            if @post_comment.save
                format.html { redirect_to post_path(@post),
                              notice: 'Post comment was successfully created.' }
                format.json { render action: 'show', status: :created, location: post_post_comment_url(@post, @post_comment) }
            else
                format.html { render action: 'new' }
                format.json { render json: @post_comment.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /post_comments/1
    # PATCH/PUT /post_comments/1.json
    def update
        respond_to do |format|
            if @post_comment.update(post_comment_params)
                format.html { redirect_to @post_comment,
                              notice: 'Post comment was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @post_comment.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /post_comments/1
    # DELETE /post_comments/1.json
    def destroy
        @post_comment.destroy
        respond_to do |format|
            format.html { redirect_to @post }
            format.json { head :no_content }
        end
    end

    private

    def set_post_and_comment
        @post = Post.find(params[:post_id])
        @post_comment = @post.post_comments.find(params[:id])
    end

    def prepare_markdown
        @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_comment_params
        params.require(:post_comment).permit(:text)
    end
end
