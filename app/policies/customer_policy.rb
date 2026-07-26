class CustomerPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin? ||
    user.id == record.user_id
  end

  def destroy?
    user.admin?
  end
end
