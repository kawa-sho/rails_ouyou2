class MessagesController < ApplicationController
  def create
    #紐づきの確認
    #entryのどこかに自分のidが存在しかつ:messageと:room_idのキーがちゃんと入っているか
    if Entry.where(:user_id => current_user.id, :room_id => params[:message][:room_id]).present?
      @message = Message.create(message_params.merge(:user_id => current_user.id))
    end
     redirect_to request.referer
  end





  private

  def message_params
    params.require(:message).permit(:user_id, :content, :room_id)
  end
end
