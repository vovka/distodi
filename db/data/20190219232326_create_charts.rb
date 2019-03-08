class CreateCharts < ActiveRecord::Migration
  def up
    [
      {
        name: "Total costs by months",
        chart_type: :bar,
        active: true,
        label_attribute: "month",
        format: ["strftime", "%Y %m"],
        data_attribute: "total",
        select: "date_trunc('month', created_at) as month, sum(price) as total",
        group: "month",
        order: "month",
        single_serial: true,
        position: 1
      },
      {
        name: "All services",
        chart_type: :pie,
        active: true,
        label_attribute: "count",
        data_attribute: "count",
        select: "count(id) as count",
        position: 2
      },
      {
        name: "Total costs",
        chart_type: :doughnut,
        active: true,
        label_attribute: "sum",
        data_attribute: "sum",
        select: "sum(price) as sum",
        position: 3
      },
      {
        name: "Service types count",
        chart_type: :pie,
        active: true,
        label_attribute: "service_kind_title",
        data_attribute: "count",
        select: "count(services.id), service_kinds.title as service_kind_title",
        joins: "service_kinds",
        group: "service_kinds.id",
        position: 4
      },
      {
        name: "Confirmed services",
        chart_type: :pie,
        active: true,
        label_attribute: "not_confirmed",
        data_attribute: "count",
        select: "(company_id IS NOT NULL AND confirmed IS NULL) as not_confirmed, "\
          "count(id)",
        group: "not_confirmed",
        position: 5
      }
    ].each do |attributes|
      Chart.create!(attributes)
    end
  end

  def down
    Chart.destroy_all
  end
end
