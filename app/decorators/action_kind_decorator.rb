class ActionKindDecorator < Draper::Decorator
  CONTROL_TITLE = "Control".freeze
  CHANGE_TITLE = "Change".freeze
  TUNING_TITLE = "Tuning".freeze

  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def icon_class
    case title
    when CONTROL_TITLE
      "control-action"
    when CHANGE_TITLE
      "change-action"
    when TUNING_TITLE
      "tuning-action"
    end
  end
end
