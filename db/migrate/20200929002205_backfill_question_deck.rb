# frozen_string_literal: true

class BackfillQuestionDeck < ActiveRecord::Migration[6.0]
  def up
    game_owner = User.find_by(admin: true)
    default_deck = game_owner.decks.create!(name: 'Official 1')

    Question.all.each do |question|
      question.update!(deck: default_deck)
    end
    data_check
  end

  def down
  end

  def data_check
    # Write a query that ensures your `up` method has the expected outcome.
    default_deck = Deck.find_by(name: 'Official 1')
    expected_results = Question.all.pluck(:deck_id).uniq
    raise "DATA MIGRATION FAILED" unless expected_results.length == 1
  end
end
