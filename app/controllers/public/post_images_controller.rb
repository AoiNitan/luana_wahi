class Public::PostImagesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]


  def new
    @post_image = PostImage.new
  end

  def create
    @post_image = PostImage.new(post_image_params)


  end
end
