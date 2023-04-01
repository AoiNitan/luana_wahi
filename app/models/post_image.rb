class PostImage < ApplicationRecord

  has_one_attached :image

  has_many :notifications, dependent: :destroy

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

  def create_notification_image_like(current_user)
    #既にいいねされているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_image_id = ?", current_user.id, user_id, id, 'image_like'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_image_id: id,
        visited_id: user_id,
        action: 'image_like'
        )
      #自分の投稿に対するいいねの場合通知済み
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end


  def create_notification_image_comment(current_user, post_image_comment_id)
    #自分以外にコメントしている人すべてを取得し全員に通知
    temp_ids = PostImageComment.select(:user_id).where(post_image_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_post_image_comment(current_user, post_image_comment_id, temp_id['user_id'])
    end
    #まだ誰もコメントしていない場合投稿者に送る
    save_notification_post_image_comment(current_user, post_image_comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_post_image_comment(current_user, post_image_comment_id, visited_id)
    #コメントは複数回投稿可能なので１つの投稿に複数回通知
    notification = current_user.active_notifications.new(
      post_image_id: id,
      post_image_comment_id: post_image_comment_id,
      visited_id: visited_id,
      action: 'image_comment'
      )
    #自分の投稿に対するコメントの場合通知済み
    if notification.visitor_id == notification.visited_id
        notification.checked = true
    end
    notification.save if notification.valid?
  end


#検索分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @post_image = PostImage.where("title LIKE?", "#{word}")
    elsif search == "forward_match"
      @post_image = PostImage.where("title LIKE?", "#{word}%")
    elsif search == "backward_match"
      @post_image = PoatImage.where("title LIKE?", "%#{word}")
    elsif search == "partial_match"
      @post_image = PostImage.where("title LIKE?", "%#{word}%")
    else
      @post_image = PostImage.all
    end
  end
end
