class Chart < ActiveRecord::Base
  class ConfirmedServices < Base
    def labels
      service_counts_grouped_by_confirmation
        .map(&:not_confirmed)
        .map { |value| value ? :confirmed : :not_confirmed }
    end

    def series
      chart.name
    end

    def data
      service_counts_grouped_by_confirmation.map(&:count)
    end

    private

    def service_counts_grouped_by_confirmation
      @_service_counts_grouped_by_confirmation_memo ||= chart
        .item.services
        .where(performed_at: chart.from_date..chart.to_date)
        .select(
          "(company_id IS NOT NULL AND confirmed IS NULL) as not_confirmed, "\
          "count(id)"
        )
        .group(:not_confirmed)
        .to_a
    end
  end
end
