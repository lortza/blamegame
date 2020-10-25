# frozen_string_literal: true

json.array! @decks, partial: 'decks/deck', as: :deck
