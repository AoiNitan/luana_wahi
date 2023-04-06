class Public::PostBlogCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    post_blog = PostBlog.find(params[:post_blog_id])
    post_blog_comment = current_user.post_blog_comments.new(post_blog_comment_params)
    post_blog_comment.post_blog_id = post_blog.id
    post_blog_comment.save
    post_blog.create_notification_blog_comment(current_user, post_blog_comment_id)
    redirect_to post_blog_path(post_blog)
  end

  def destroy
    PostBlogComment.find(params[:id]).destroy
    redirect_to post_blog_path(params[:post_blog_id])
  end

  private

  def post_blog_comment_params
    params.require(:post_blog_comment).permit(:blog_comment)
  end

end
