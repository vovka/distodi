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
    author? && record.requires_action?
  end

  def show?
    author? || record.approver?(user)
  end

  def update?
    edit?
  end

  def destroy?
    author? && (!record.approved? || self_approved?)
  end

  def approve?
    record.approver?(user) && record.requires_action?
  end

  def approver?
    record.approver?(user) && record.status == "pending"
  end

  alias_method :decline?, :approve?

  private

  def author?
    record.item.present? && record.item.user == user
  end

  def self_approved?
    record.approved? && (record.approver.nil? || record.approver == user)
  end
end
