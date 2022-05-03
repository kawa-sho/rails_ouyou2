class RoomsController < ApplicationController

  def create
    @room = Room.create
    #entryに作ったroom_idと自分のuser_idを渡して作る
    @entry1 = Entry.create(:room_id => @room.id, :user_id => current_user.id)
    #entryに相手のエントリー情報を作る
    @entry2 = Entry.create(entry_params.merge(:room_id => @room.id))
    #部屋に飛ぶ
    redirect_to "/rooms/#{@room.id}"
  end

  def show
    @room = Room.find(params[:id])
    #渡したroomの情報の中に自分のidが存在するかどうか
    if Entry.where(:user_id => current_user.id, :room_id => @room.id).present?
    #やり取りしたメッセージの抽出
      @messages = @room.messages
    #新しいメッセージの作成
      @message = Message.new
    #roomにいるユーザの抽出
      @entries = @room.entries
    else
    #直前のサイトに戻る、戻れなければroot_pathに飛ぶ
      redirect_back(fallback_location: root_path)
  end

  private

  def entry_params
    params.require(:entry).permit(:user_id, :room_id)
  end
end
