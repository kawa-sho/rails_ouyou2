class RelationshipsController < ApplicationController

  def followings
    @users = User.all
  end

  def followers
    @users = User.all
  end

  def create
    if current_user == User.find(params[:user_id])
      redirect_to request.referer
    else
      current_user.follow(params[:user_id])
      redirect_to request.referer
    end
  end

  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end

  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end
end
