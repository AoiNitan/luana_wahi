class PostImageComment < ApplicationRecord

  belongs_to :user
  belongs_to :post_image

  has_many :notifications, dependent: :destroy
end
