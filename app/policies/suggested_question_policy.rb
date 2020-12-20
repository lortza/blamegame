# frozen_string_literal: true

class SuggestedQuestionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end

  def index?
    user&.admin?
  end
end
