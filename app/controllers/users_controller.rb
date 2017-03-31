class UsersController < ApplicationController
  before_action :signed_in_user, 
        only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
   # @users = User.all
     @users = User.paginate(page: params[:page])
  end
  
  def new #user regester
  	@user =User.new
  end

  def show #show user's information
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create #create new user
  	@user = User.new(user_params) # Not the final implementation!
  	if @user.save
  		# Handle a successful save.
      sign_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit  #edit user information.
#    @user = User.find(params[:id])
  end

  def update #update user information
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      #Handle a successful update
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end    
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end    


  private
  	def user_params
  		params.require(:user).permit(:name, :email, :password, 
  										:password_confirmation)
  	end

    # before filters
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
