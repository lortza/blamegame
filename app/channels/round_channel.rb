class RoundChannel < ApplicationCable::Channel
  def subscribed
    stream_for round
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def round
    # The params are populated in the round_channel.js
    Round.find(params[:round_id])
  end
end
