class PostBlog < ApplicationRecord

  belongs_to :user
  has_many :post_blog_comments, dependent: :destroy
  has_many :post_blog_favorites, dependent: :destroy

  has_many :notifications, dependent: :destroy

  validates :title_blog, presence: true
  validates :content_blog, presence: true

  #メソッド作成
  def blog_favorited_by?(user)
    post_blog_favorites.exists?(user_id: user.id)
  end

  # def create_notification_blog_like(current_user)
  #   #既にいいねされているか検索
  #   temp = Notification.where(["visitor_id = ? and visited_id = ? and post_blog_id = ?", current_user.id, user_id, id, 'blog_like'])
  #   if temp.blank?
  #     notification = current_user.active_notifications.new(
  #       post_blog_id: id,
  #       visited_id: user_id,
  #       action: 'blog_like'
  #       )
  #     #自分の投稿に対するいいねの場合通知済み
  #     if notification.visitor_id == notification.visited_id
  #       notification.checked = true
  #     end
  #     notification.save if notification.valid?
  #   end
  # end

  def create_notification_blog_comment(current_user, post_blog_comment_id)
    #自分以外にコメントしている人すべてを取得し全員に通知
    temp_ids = PostBlogComment.select(:user_id).where(post_blog_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_post_blog_comment(current_user, post_blog_comment_id, temp_id['user_id'])
    end
    #まだ誰もコメントしていない場合投稿者に送る
    save_notification_post_blog_comment(current_user, post_blog_comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_post_blog_comment(current_user, post_blog_comment_id, visited_id)
    #コメントは複数回投稿可能なので１つの投稿に複数回通知
    notification = current_user.active_notifications.new(
      post_blog_id: id,
      post_blog_comment_id: post_blog_comment_id,
      visited_id: visited_id,
      action: 'blog_comment'
      )
    #自分の投稿に対するコメントの場合通知済み
    if notification.visitor_id == notification.visited_id
        notification.checked = true
    end
    notification.save if notification.valid?
  end

end
