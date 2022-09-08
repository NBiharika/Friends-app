 class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy friend_posts]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # GET /posts or /posts.json
  def index
    @posts = Post.most_recent
    @users = User.all
    @friends = Friend.all
    #@friends = User.friends.where('friends.email == ?', users.email)
    #@friends = User.friends.where('user_id IN (#{current_user.id}, #{another_user.id})')
  end

  # GET /posts/1 or /posts/1.json
  def show
    #Rails.cache.fetch("post_key_#{params[:id]}_#{current_user.id}", expires_in: 24.hours, timetoLive: 24.hours) do 
    #end
  end

  def showFriendsPost
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  # GET /posts/new
  def new
    #@post = Post.new
    @post = current_user.posts.build
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
     @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    #Rails.cache.delete("post_key_#{params[:id]}_#{current_user.id}")

    respond_to do |format| 
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    #Rails.cache.delete("post_key_#{params[:id]}_#{current_user.id}")

    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to posts_path, notice: "Not Authorized To Edit This Post" if @post.nil?
  end

  def friend_posts
    @posts = Post.posts_by_not_current_user(current_user)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body, :description, :user_id)
    end
end
