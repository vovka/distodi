class ServicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def new?
    author?
  end

  def create?
    new?
  end

  def edit?
    author? && (self_approved? || record.requires_action?)
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  private

  def author?
    record.item.user == user
  end

  def self_approved?
    record.approved? && record.self_approvable?
  end
end
