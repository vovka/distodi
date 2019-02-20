class Chart < ActiveRecord::Base
  class Base
    attr_reader :chart
    private     :chart

    def initialize(chart)
      @chart = chart
    end

    def labels
      %w(January February March April May June July)
    end

    def series
      ['Series A', 'Series B']
    end

    def data
      [
        [65, 59, 80, 81, 56, 55, 40],
        [28, 48, 40, 19, 86, 27, 90]
      ]
    end
  end
end
