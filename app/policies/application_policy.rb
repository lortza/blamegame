# frozen_string_literal: true

# The redirect to root_url is coming from the
# user_not_authorized method in the ApplicationController
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end

  private

  def user_is_admin?
    # only allow action to run if the current_user is admin
    user&.admin?
  end


  def user_is_owner_of_record_or_admin?
    # only allow action to run if the current_user on their own recipe
    (record.user_id == user&.id) || user&.admin?
  end
end
