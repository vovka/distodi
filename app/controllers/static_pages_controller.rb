class StaticPagesController < ApplicationController
  layout "new"

  def home
    if user_signed_in?
      redirect_to dashboard_path
    elsif company_signed_in?
      redirect_to current_company
    end
  end

  def security

  end

  def tutorialcar

  end

  def about

  end

  def terms

  end

  def careers

  end
end
