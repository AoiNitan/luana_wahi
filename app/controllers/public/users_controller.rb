class Public::UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @post_images = @user.post_images.page(params[:page])
  end



  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(user_params)
    redirect_to users_my_page_path(@user.id)
  end

  def unsubscribe
    @user = current_user
  end

  def withdraw
    @user = current_user
    @user.update(is_deletef: true)
    reset_session
    redirect_to root_path
  end

  def favorites
    @user = User.find(params[:id])
    image_favorites = PostImageFavorite.where(user_id: @user.id).pluck(:post_image_id)
    @favorite_images = PostImage.find(image_favorites)

    blog_favorites = PostBlogFavorite.where(user_id: @user.id).pluck(:post_blog_id)
    @favorite_blogs = PostBlog.find(blog_favorites)
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image)
  end

end
