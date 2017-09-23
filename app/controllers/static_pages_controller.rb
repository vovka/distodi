class StaticPagesController < ApplicationController
  layout "new", only: [:home]

  def home
    if user_signed_in?
      redirect_to dashboard_path
    elsif company_signed_in?
      redirect_to current_company
    end
  end

  def tutorial
  end

  def tutorialcar
  end

  def tutorialbike
  end

  def about
  end
end
