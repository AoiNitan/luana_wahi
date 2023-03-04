class Public::PostBlogFavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
  post_blog = PostBlog.find(params[:post_blog_id])
  post_blog_favorite = current_user.post_blog_favorites.new(post_blog_id: )


end
end
