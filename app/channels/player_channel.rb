class PlayerChannel < ApplicationCable::Channel
  def subscribed
    # stream_for 'player'
    stream_from 'player_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def round
    Player.find(params[:player_id])
  end
end
