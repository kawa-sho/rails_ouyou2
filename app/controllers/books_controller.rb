class BooksController < ApplicationController

before_action :correct_user, only: [:edit, :update]

  def show
    @book = Book.find(params[:id])
    @books = Book.new
    @user = @book.user
    @book_comment = BookComment.new
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.view_counts.create(book_id: @book.id)
    end
  end

  def index
    @book = Book.new
    #一週間のいいねの多い順
    #今日の終わり
    to = Time.current.at_end_of_day
    #一週間前
    from = (to - 6.day).at_beginning_of_day
    #favoriteとuserを取り出しておいて、一週間前から今日の終わりまででのいいね数でソートする
    @books = Book.includes(:favorited_users).
      sort_by {|x|
        x.favorites.where(created_at: from...to).size
      }.reverse
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
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

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    redirect_to(books_path) unless @user == current_user
  end

end
