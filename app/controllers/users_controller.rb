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

    #DM機能の作成
    #自分のエントリー情報を抽出
    @currentUserEntry = Entry.where(user_id: current_user.id)
    #見てるページのユーザーのエントリー情報を抽出
    @userEntry = Entry.where(user_id: @user.id)
    #見てるページのユーザーと自分のユーザーがおんなじかどうか
    if @user.id == current_user.id
    else
    #自分の持ってるエントリー情報と見てるページのユーザーのエントリー情報をすべて抽出する
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
    #自分の持ってるroom_idと見てるページのユーザーの持ってるroom_idの中に同じroom_idがあるかどうか
          if cu.room_id == u.room_id then
    #roomはあるよと定義しroom_idをインスタンス変数で渡す
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
    #roomがない場合
      if @isRoom
      else
    #新しいインスタンスを制作する
        @room = Room.new
        @entry = Entry.new
      end
    end
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
