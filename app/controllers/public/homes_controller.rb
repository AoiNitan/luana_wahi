class Public::HomesController < ApplicationController

  before_action :set_post_images, only: [:top]

  def top
    @post_images = @new_post_images.first(4)
  end

  private

  def set_post_images
    @new_post_images = PostImage.all.order('created_at DESC')
  end

end
