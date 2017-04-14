class StaticPagesController < ApplicationController
  before_filter :set_layout, only: :home

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

  private

  def set_layout
    layout = if params.include?(:new)
      "new"
    else
      "application"
    end
    self.class.layout(layout, only: :home)
  end
end
