# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  before_action :set_sentry_context

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def valid_player_present?(game)
    player_id = cookies[:player_id].to_i
    return false if player_id.blank?

    game.players.pluck(:id).include?(player_id)
  end

  private

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referer || root_path)
  end

  def set_sentry_context
    Sentry.user_context(id: session[:current_user_id]) # or anything else in session
    Sentry.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
