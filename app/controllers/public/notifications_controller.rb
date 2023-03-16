class Public::NotificationsController < ApplicationController

  def index
    @notifications = current_user.passive_notifications.page(params[:page]).per(10)
    @notifications.where(checked: false).each do |notifications|
      notifications
  end

end
