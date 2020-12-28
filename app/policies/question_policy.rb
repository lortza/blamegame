# frozen_string_literal: true

class QuestionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end

  def create?
    user_is_owner_of_record_or_admin?
  end

  def edit?
    user_is_owner_of_record_or_admin?
  end

  def update?
    user_is_owner_of_record_or_admin?
  end

  def convert_from_suggestion?
    user&.admin?
  end

  private

  def user_is_owner_of_record_or_admin?
    # only allow action to run if the current_user on their own record
    (record.deck.user_id == user&.id) || user&.admin?
  end
end
