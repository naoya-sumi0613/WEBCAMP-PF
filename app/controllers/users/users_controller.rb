class Users::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :retire]

  def show
  	@user = User.find(params[:id])
    @array = []
    @photos = Photo.where(user_id: params[:id])

  	if @user == current_user
  		@name = "あなた"
  	else
  		@name = "#{@user.last_name}#{@user.first_name}さん"
  	end

    @photos.each do |photo|
      if photo.range == "全ユーザー"
        @array.push(photo)
      elsif photo.range == "フォロワーのみ"
        if current_user.following?(photo.user) || photo.user.id == current_user.id
          @array.push(photo)
        end
      else
        if photo.user.id == current_user.id
          @array.push(photo)
        end
      end
    end

    @photos_array = Kaminari.paginate_array(@array).page(params[:page]).per(12)
  end

  def edit
  	@user = User.find(params[:id])
  end

  def update
  	@user = User.find(params[:id])
  	if @user.update(user_params)
  	  redirect_to user_path(params[:id])
    else
      render "edit"
    end
  end

  def retire
  end

  def destroy
  	@user = User.find(current_user.id)
  	@user.destroy
  	redirect_to root_path
  end

  def follow
    @user = User.find(params[:id])
    @users = @user.following_user.page(params[:page]).per(10)
  end

  def follower
    @user = User.find(params[:id])
    @users = @user.follower_user.page(params[:page]).per(10)
  end



  private
  def user_params
  	params.require(:user).permit(:image, :last_name, :first_name, :read_last_name, :read_first_name, :email, :introduction)
  end

  def correct_user
    if current_user != User.find(params[:id])
      redirect_to user_path(current_user)
    end
  end
end
