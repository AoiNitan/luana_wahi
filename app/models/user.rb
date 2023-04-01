class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # フォローをした、されたの関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # 一覧画面で使う
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower

  #通知モデルとの関係（上が自分からの通知、下が相手からの通知）
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy


  has_one_attached :profile_image
  has_many :post_images, dependent: :destroy
  has_many :post_images_comments, dependent: :destroy
  has_many :post_images_favorites, dependent: :destroy

  has_many :post_blogs, dependent: :destroy
  has_many :post_blogs_comments, dependent: :destroy
  has_many :post_blogs_favorites, dependent: :destroy

  #メソッド作成
  def get_profile_image(width,height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/sample.jpg')
      profile_image.attach(io: File.open(file_path), filename:'default-image.jpg', content_type:'image/jpeg')
    end
    profile_image.variant(resize_to_limit:[width,height]).processed
  end

    # フォローしたときの処理
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  # フォローを外すときの処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  # フォローしているか判定
  def following?(user)
    followings.include?(user)
  end

  #フォロー通知メソッド
  def create_notification_follow(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ?", current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  #ゲストログイン
  def self.guest
    find_or_create_by!(email: 'abc@aaa.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.password_confirmation = user.password
      user.name = 'ゲスト'
    end
  end

#検索分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?", "#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?", "%#{word}")
    elsif search == "partial_match"
      @user = USer.where("name LIKE?", "%#{word}%")
    else
      @user = USer.all
    end
  end

end
