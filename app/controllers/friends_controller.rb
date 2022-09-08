class FriendsController < ApplicationController
  before_action :set_friend, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  #before_action :doorkeeper_authorize!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]
  #skip_before_action :verify_authenticity_token

  # GET /friends
  # GET /friends.json

  def users
   #@users  = User.paginate(:page => params[:page], :per_page=>10)
   #@friends = current_user.friends
   @friends = Friend.where(foreign_id: current_user.id)
   #@users = User.all_except(current_user)
   @users = User.where.not(id: current_user.id) 

  end

  def add
    @user = User.find(params[:id])
    @friends = current_user.friends.all

    if @user != current_user 
      @friend = current_user.friends.where(user_id: @user.id)
      if @friend.empty?
         @sentfriendrequest = current_user.friends.new(user_id: @user.id, foreign_id: current_user.id, status: "sent")
         @sentfriendrequest.save 
         @pendingfriendrequest = @user.friends.new(user_id: current_user.id, foreign_id: @user.id, status: "pending")
         @pendingfriendrequest.save
          if @sentfriendrequest.save and @pendingfriendrequest.save
             redirect_to users_path, notice: "Friend request sent"
          else
             redirect_to users_path, notice: "Unable to add this friend"
          end
      else
        friend = current_user.friends.where(status: "accepted", user_id: @user.id)
        if !friend.empty?
          redirect_to users_path, notice: "This friend is already added"
        else
          friend = current_user.friends.where(status: "pending", user_id: @user.id)
          if !friend.empty?
            redirect_to requests_path, notice: "Pending friend request"
          else
            redirect_to users_path, notice: "Already sent the friend request"
          end
       end
      end
    else
      redirect_to users_path, notice: "Can't add yourself as friend"
    end
  end

  def requests
    @users = User.all 
    @requiredFriends = Friend.where(foreign_id: current_user.id, status: 'pending')
  end

  def accept
    @user = User.find(params[:id])
    @friend = Friend.where(user_id: @user.id, foreign_id: current_user.id, status: 'pending')
    @friend.update(status: 'accepted')
    @incomingfriend = Friend.where(user_id: current_user.id, foreign_id: @user.id, status: 'sent')
    @incomingfriend.update(status: 'accepted')

    if @friend.update(status: 'accepted')
       redirect_to friends_path, notice: "You are now friends with #{@user.first_name}"
    end
  end

  def decline
     @user = User.find(params[:id])
     @friend = Friend.find_by(user_id: @user.id, foreign_id: current_user.id, status: 'pending')
     @friend.destroy
     @incomingfriend = Friend.find_by(user_id: current_user.id, foreign_id: @user.id, status: 'sent')
     @incomingfriend.destroy

     respond_to do |format|
      format.html { redirect_to users_url, notice: "Friend request declined" }
      format.json { head :no_content }
    end

  end

  def index
    @users = User.all 
    @requiredFriends = Friend.where(foreign_id: current_user.id, status: 'accepted')
  end

  # GET /friends/1
  # GET /friends/1.json
  def show
    #Rails.cache.fetch("test_key_#{params[:foreign_id]}_#{current_user.id}", expires_in: 24.hours, timetoLive: 24.hours) do 
      @friend = Friend.find(params[:id])
      @user = User.where(id: @friend.user_id)
      #@users = User.all
    #end
  end

  # GET /friends/new
  def new
    @friend = Friend.new
  end

  # GET /friends/1/edit
  def edit
  end

  def search 
    @users = User.where("email LIKE ?", "%" + params[:q] + "%")
  end

  # POST /friends
  # POST /friends.json
  def create
      @friend = current_user.friends.build(friend_params)
      respond_to do |format|
        if @friend.save
          format.html { redirect_to @friend, notice: 'Friend was successfully created.' }
          format.json { render :show, status: :created, location: @friend }
        else
          format.html { render :new }
          format.json { render json: @friend.errors, status: :unprocessable_entity }
       # end
      end
    end
  end

  # PATCH/PUT /friends/1
  # PATCH/PUT /friends/1.json
  def update
    #Rails.cache.delete("test_key_#{params[:id]}_#{current_user.id}")

    respond_to do |format|
      if @friend.update(friend_params)
        format.html { redirect_to @friend, notice: 'Friend was successfully updated.' }
        format.json { render :show, status: :ok, location: @friend }
      else
        format.html { render :edit }
        format.json { render json: @friend.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friends/1
  # DELETE /friends/1.json

  def destroy
    @friend.destroy

    respond_to do |format|
      format.html { redirect_to friends_url, notice: "Removed friendship" }
      format.json { head :no_content }
    end
  end


  def correct_user
    @friend = current_user.friends.find_by(id: params[:id])
    redirect_to friends_path, notice: "Not Authorized To Edit This Friend" if @friend.nil?
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friend
      @friend = Friend.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def friend_params
      params.require(:friend).permit(:user_id, :foreign_id, :status)
    end

end