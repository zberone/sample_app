class UsersController < ApplicationController
  before_action :signed_in_user, only:[:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.all
  end
  
  def new #user regester
  	@user =User.new
  end

  def show #show user's information
  	@user = User.find(params[:id])
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


  private
  	def user_params
  		params.require(:user).permit(:name, :email, :password, 
  										:password_confirmation)
  	end

    # before filters
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

end
