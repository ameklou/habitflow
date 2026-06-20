class ReminderPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    owns_record?
  end

  def create?
    user.present? && (record.habit.nil? || record.habit.user_id == user.id)
  end

  def update?
    owns_record?
  end

  def destroy?
    owns_record?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none unless user

      scope.joins(:habit).where(habits: { user_id: user.id })
    end
  end

  private

  def owns_record?
    user.present? && record.habit.user_id == user.id
  end
end
