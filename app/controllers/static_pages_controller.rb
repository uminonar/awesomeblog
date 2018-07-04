class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # @microposts = current_user.microposts.paginate(page: params[:page])
      @micropost = current_user.microposts.build
      
      @feed_items = current_user.feed_items.includes(:user).order(created_at: :desc).paginate(page: params[:page], per_page: 15)
    end
  end
end

