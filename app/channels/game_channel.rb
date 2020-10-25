# frozen_string_literal: true

class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_for game
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def game
    # The params are populated in the game_channel.js
    Game.find_by(id: params[:game_id])
  end
end
