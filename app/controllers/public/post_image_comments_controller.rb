class Public::PostImageCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    post_image = PostImage.find(params[:post_image_id])
    post_image_comment = current_user.post_image_comments.new(post_image_comment_params)
    post_image_comment.post_image_id = post_image.id
    post_image_comment.save
    redirect_to post_image_path(post_image)
  end

  def destroy
    PostImageComment.find(params[:id]).destroy
    redirect_to post_image_path(params[:post_image_id])
  end

  private

  def post_image_comment_params
    params.require(:post_image_comment).permit(:image_comment)
  end

end
