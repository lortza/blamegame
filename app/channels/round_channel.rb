class RoundChannel < ApplicationCable::Channel
  def subscribed
    # stream_for round
    stream_from 'round_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def round
    Round.find(params[:round_id])
  end
end
