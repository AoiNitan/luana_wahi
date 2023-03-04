class Public::HomesController < ApplicationController

  before_action :set_post_images, only: [:top]

  def top
    @post_images = @new_post_items.first(4)
  end

  private

  def set_post_items
    @new_post_items = PostItem.all.order('created_at DESC')
  end

end
