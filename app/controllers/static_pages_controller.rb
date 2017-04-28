class StaticPagesController < ApplicationController
  layout "new", only: [:home]

  def home
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
