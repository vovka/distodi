class CreateCharts < ActiveRecord::Migration
  def up
    [
      {
        name: "Total costs by months",
        chart_type: :bar,
        active: true
      },
      {
        name: "All services",
        chart_type: :pie,
        active: true
      },
      {
        name: "Total costs",
        chart_type: :doughnut,
        active: true
      },
      {
        name: "Service types count",
        chart_type: :pie,
        active: true
      },
      {
        name: "Confirmed services",
        chart_type: :pie,
        active: true
      }
    ].each do |attributes|
      Chart.create!(attributes)
    end
  end

  def down
    Chart.destroy_all
  end
end
