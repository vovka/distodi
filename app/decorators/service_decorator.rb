class ServiceDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def permissions(user)
    {
      delete: ServicePolicy.new(user, self).destroy?
    }
  end

  def predefined_reminders
    object.class::PREDEFINED_REMINDERS.keys.map.with_index do |name, i|
      [i, I18n.t("activerecord.models.service.attributes.predefined_reminders.#{name}")]
    end
  end
end
