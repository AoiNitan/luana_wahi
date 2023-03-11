class PostBlogComment < ApplicationRecord

  belongs_to :user
  belongs_to :post_blog

  has_many :notifications, dependent: :destroy
end
