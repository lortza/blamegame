# frozen_string_literal: true

module GamesHelper
  # rubocop:disable Rails/OutputSafety

  def display_player_names(game)
    players = game.players
    return nil if players.blank?

    winner = game.winner
    output = "#{winner_intro(winner)}, "
    everyone_else = players - [winner]
    output += everyone_else.map(&:name).join(', ')
    output.html_safe
  end

  def display_deck_names(game)
    game.decks.map(&:name).join(', ')
  end

  def display_deck_names(game)
    game.decks.map(&:name).join(', ')
  end

  def display_player_names_and_points(game)
    players = game.players
    return link_to 'Add Players', edit_game_path(game) if players.blank?

    everyone_else = players - [game.winner]
    output = ''
    output += everyone_else.map do |player|
      "#{player.name}: #{pluralize(player.rounds_won, 'round')}"
    end.join(' | ')
    output.html_safe
  end

  def rounds_won_as_emojis(player)
    emojis = ''
    player.rounds_won.times do |_win|
      emojis += '⭐ '
    end
    emojis
  end

  def overall_votes_as_emojis(player)
    emojis = ''
    player.votes.times do |_vote|
      emojis += '✅ '
    end
    emojis
  end

  def winner_icon
    "<i class='fas fa-crown'></i>"
  end

  def tie_icon
    '<i class="far fa-handshake"></i>'
  end

  def share_link(game)
    "#{root_url}play/#{game.code}"
  end

  def form_decks(user)
    return (Deck.default_decks + user.decks.order(:name)) unless user.admin?

    user.decks.order(:name)
  end

  private

  def winner_intro(winner)
    winner ? "#{winner_icon} <strong>#{winner.name}</strong>" : "#{tie_icon} Tied"
  end

  # rubocop:enable Rails/OutputSafety
end
