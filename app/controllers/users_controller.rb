class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update]

  def show
    @user = User.find(params[:id])
    @book = Book.new
    @books = @user.books.all
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
     user_id = params[:id].to_i
  unless user_id == current_user.id
    redirect_to user_path(current_user)
  end
    @user = current_user
  end

  def update
@user = current_user
    if @user.update(user_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path(@user.id)
    else
      render "edit"
    end
  end

   def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
    redirect_to user_path(current_user)
    end
   end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end


end
