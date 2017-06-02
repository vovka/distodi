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

  def approve?
    record.approver?(user) && record.requires_action?
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
