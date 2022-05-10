class BooksController < ApplicationController

before_action :correct_user, only: [:edit, :update]

  def show
    @book = Book.find(params[:id])
    @books = Book.new
    @user = @book.user
    @book_tags = @book.tags
    @book_comment = BookComment.new
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.view_counts.create(book_id: @book.id)
    end

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
    @book = Book.new
    @tag_list = Tag.all.sort_by {|x| x.books.count}.reverse
    #一週間のいいねの多い順
    #今日の終わり
    to = Time.current.at_end_of_day
    #一週間前
    from = (to - 6.day).at_beginning_of_day
    if params[:latest]
      @books = Book.latest
      #render :sort_index
    elsif params[:rate_count]
      @books = Book.rate_count
      #render :sort_index
    else
      #favoriteとuserを取り出しておいて、一週間前から今日の終わりまででのいいね数でソートする
      @books = Book.includes(:favorited_users).
      sort_by {|x|
        x.favorites.where(created_at: from...to).size
      }.reverse
    end
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    tag_list=params[:book][:name].split(',')
    if @book.save
      @book.save_tag(tag_list)
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @edit = true
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    tag_list=params[:book][:name].split(',')
    if @book.update(book_params)
      @book.save_tag(tag_list)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def search_tag
  #検索結果画面でもタグ一覧表示
    @tag_list=Tag.all
　#検索されたタグを受け取る
    @tag=Tag.find(params[:tag_id])
　#検索されたタグに紐づく投稿を表示
    @posts=@tag.posts.page(params[:page]).per(10)
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :rate)
  end

  def correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    redirect_to(books_path) unless @user == current_user
  end

end
