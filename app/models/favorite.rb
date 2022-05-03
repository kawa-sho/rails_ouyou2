class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :book
  #一つの本に対して、一人につき一つしかいいねをつけられない。
  validates_uniqueness_of :book_id, scope: :user_id
end
