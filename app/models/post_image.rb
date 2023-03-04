class PostImage < ApplicationRecord

  has_one_attached :image

  belongs_to :user
  has_many :post_images_comments, dependent: :destroy
  has_many :post_images_favorites, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: :true

  #メソッド作成
  def image_favorited_by?(user)
    post_images_favorites.exists?(user_id: user.id)
  end

  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io:File.open(file_path), filename: 'default-image.jpg', content_type:'image/jpg')
    end
    image
  end

end
