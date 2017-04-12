class ItemPolicy
  attr_reader :user, :item
  private :user, :item

  def initialize(user, item)
    @user = user
    @item = item
  end

  def show_for_company?
    if item.token.present?
      author?
    else
      throw :warden, scope: :company
    end
  end

  def edit?
    author?
  end

  def update?
    author?
  end

  def destroy?
    author?
  end

  private

  def author?
    item.user == user
  end
end
