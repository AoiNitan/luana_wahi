class PostBlog < ApplicationRecord

  belongs_to :user
  has_many :post_blogs_comments, dependent: :destroy
  has_many :post_blogs_favorites, dependent: :destroy

  validates :title_blog, presence: true
  validates :content_blog, presence: true

  #メソッド作成
  def blog_favorited_by?(user)
    post_blog_favorites.exists?(user_id: user.id)
  end

end
