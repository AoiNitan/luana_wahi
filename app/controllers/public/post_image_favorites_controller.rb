class Public::PostImageFavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    post_image = PostImage.find(params[:post_image_id])
    favorite = current_user.post_image_favorites.new(post_image_id: post_image.id)
    favorite.save
    # post_image.create_notification_image_like(current_user)
    redirect_to post_image_path(post_image)
  end

  def destroy
    post_image = PostImage.find(params[:post_image_id])
    favorite = current_user.post_image_favorites.find_by(post_image_id: post_image.id)
    favorite.destroy
    redirect_to post_image_path(post_image)
  end

end
