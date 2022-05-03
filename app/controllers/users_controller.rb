class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @book = Book.new
    #一週間のいいねの多い順
    #今日の終わり
    to = Time.current.at_end_of_day
    #一週間前
    from = (to - 6.day).at_beginning_of_day
    #favoriteとuserを取り出しておいて、一週間前から今日の終わりまででのいいね数でソートする
    @books = @user.books.includes(:favorited_users).
      sort_by {|x|
        x.favorites.where(created_at: from...to).size
      }.reverse
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(params[:id]), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction)
  end

  def correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
