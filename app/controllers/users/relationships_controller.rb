class Users::RelationshipsController < ApplicationController
  def follow
    @user = User.find(params[:user_id])
  	current_user.follow(params[:user_id])
    @user.create_notification_follow!(current_user)
  end

  def unfollow
    @user = User.find(params[:user_id])
  	current_user.unfollow(params[:user_id])
  end


  private
  def relationship_params
  	params.require(:relationship).permit(:user_id)
  end

end
