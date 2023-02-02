class Book < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  validates :title,presence: true
  validates :body,presence: true,length:{maximum:200}
  
  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end
  
   def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
   end
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
