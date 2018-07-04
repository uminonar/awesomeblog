class MicropostsController < ApplicationController
  before_action :require_login, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)

    if @micropost.save
      flash['success'] = "Micrpost created!"
      redirect_to root_url
    else
      @microposts = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost = Micropost.find(params[:id])
    @micropost.destroy
    flash[:info] = "Deleted micropost successfully."

    # This method is the url from where we created our request
    redirect_to request.referrer || root_url
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      # params[:id] is from the micropost delete button
      @micropost = current_user.microposts.find_by(id: params[:id])

      if @micropost.nil?
        flash[:danger] = "You are not allowed to do that."
        redirect_to root_url
      end
    end
end