# frozen_string_literal: true

module GamesHelper
  def display_player_names(game)
    players = game.players
    return link_to 'Add Players', edit_game_path(game) unless players.present?

    winner = game.winner
    output = "#{winner_intro(winner)}, "
    everyone_else = players - [winner]
    output += everyone_else.map(&:name).join(', ')
    output.html_safe
  end

  def display_player_names_and_points(game)
    players = game.players
    return link_to 'Add Players', edit_game_path(game) unless players.present?

    everyone_else = players - [game.winner]
    output = ''
    output += everyone_else.map do |player|
      "#{player.name}: #{pluralize(player.rounds_won, 'round')}"
    end.join(' | ')
    output.html_safe
  end

  def winner_icon
    "<i class='fas fa-crown'></i>"
  end

  def tie_icon
    '<i class="far fa-handshake"></i>'
  end

  private

  def winner_intro(winner)
    winner ? "#{winner_icon} <strong>#{winner.name}</strong>" : "#{tie_icon} Tied"
  end
end
