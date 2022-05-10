class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  #includesで呼び出すときのカラム
  has_many :favorited_users, through: :favorites, source: :user
  #一週間の間のいいねを呼び出すカラム
  has_many :week_favorites, -> { where(created_at: ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day)) }, class_name: 'Favorite'
  has_many :book_comments, dependent: :destroy

  has_many :view_counts, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  scope :latest, -> {order(created_at: :desc)}
  scope :rate_count, -> {order(rate: :desc)}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search(search, word)
    if search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "perfect_match"
      @book = Book.where(title: "#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end


end
