class MeasurementCollector::Collector::EfentoTemperature
  def initialize(
    @path : String,
    @array = Array(MeasurementCollector::Meas::Temperature).new
  )
    @csv_paths = Dir[File.join([@path, "*.csv"])]
  end

  getter :array

  def parse
    @csv_paths.each do |csv_path|
      parser = MeasurementCollector::Parser::EfentoTemperature.new(
        path: csv_path
      )
      @array += parser.parse
    end

    @array = @array.sort.uniq

    return @array
  end
end
