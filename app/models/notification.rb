class Notification < ApplicationRecord

  #作成日時の降順
  default_scope -> { order(created_at: :desc) }
  #optional:trueでnil許可
  belongs_to :post_image, optional: true
  belongs_to :post_blog, optional: true
  belongs_to :post_image_comment, optional: true
  belongs_to :post_blog_comment, optional: true

  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true

end
