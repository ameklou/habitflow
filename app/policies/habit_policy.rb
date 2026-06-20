class HabitPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    owns_record?
  end

  def create?
    user.present?
  end

  def update?
    owns_record?
  end

  def archive?
    owns_record?
  end

  def complete?
    owns_record? && record.active? && !record.archived?
  end

  def undo_completion?
    owns_record?
  end

  def destroy?
    owns_record?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none unless user

      scope.where(user: user)
    end
  end

  private

  def owns_record?
    user.present? && record.user_id == user.id
  end
end
