class UsersController < ApplicationController
    
    before_action :set_user, only: [ :show, :edit, :update, :destroy]
    before_action :require_user, only: [:edit, :update]
    before_action :require_same_user, only: [:edit, :update]
    
    def show
    #   @user = User.find(params[:id])
       @articles = @user.articles.paginate(page: params[:page], per_page: 5)
    end
    
    def index
        @users = User.all.paginate(page: params[:page], per_page: 5)
    end
    
    def new
        @user = User.new
    end
    
    def create 
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id # Login session
            flash[:notice] = "Welcome to the Yodo Blog #{@user.username}, you have successfully signup"
            redirect_to @user
        else
            render 'new'
        end
    end
    
    def edit
        # @user = User.find(params[:id])
    end
    
    def update
        # @user = User.find(params[:id])
        if @user.update(user_params)
            flash[:notice] = "Your account information was updated"
            redirect_to articles_path
        else
            render 'edit'
        end
    end
    
    def destroy
        @user.destroy
        session[:user_id] = nil if @user == current_user # Log out, clear cookies except when admin delete another account
        flash[:notice] = "Account and all associated articles successfully deleted"
        redirect_to articles_path
    end
    
    
    private
    
    def user_params
        params.require(:user).permit(:username, :email, :password)
    end
    
    def set_user
        @user = User.find(params[:id])
    end
    
    # def require_user  # Moved to application_controller
    #     if !logged_in?
    #       flash[:notice] = "You must be logged in to perform that action"
    #       redirect_to login_path
    #     end
    # end
    
    def require_same_user
        if current_user != @user && !current_user.admin?
            flash[:alert] = "You can only edit or delete your own account"
            redirect_to @user
        end
        
    end
    
    
end