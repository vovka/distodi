class UserPolicy
  attr_reader :user, :current_user
  private :user, :current_user

  def initialize(current_user, user)
    @user = user
    @current_user = current_user
  end

  def show?
    current_user?
  end

  def edit?
    current_user?
  end

  def update?
    current_user?
  end

  def destroy?
    current_user?
  end

  private

  def current_user?
    user == current_user
  end
end
