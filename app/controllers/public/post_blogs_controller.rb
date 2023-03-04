class Public::PostBlogsController < ApplicationController
  before_action :authenticate_user!

  def new
    @post_blog = PostBlog.new
  end

  def create
    @post_blog = PostBlog.new(post_blog_params)
    @post_blog.user_id = current_user.id
    if @post_blog.save
      redirect_to post_blog_path(@post_blog)
    else
     render :new
    end
  end

  def index
    @post_blogs = PostBlog.page(params[:page])
  end

  def show
    @post_blog = PostBlog.find(params[:id])
    @post_blog_comment = PostBlogComment.new
  end

  def destroy
    @post_blog = PostBlog.find(params[:id])
    @post_blog.destroy
    redirect_to post_blogs_path
  end

  private

  def post_blog_params
    params.require(:post_blog).permit(:title_blog, :content_blog)
  end

end
