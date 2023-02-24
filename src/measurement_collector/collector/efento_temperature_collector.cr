class MeasurementCollector::Collector::EfentoTemperatureCollector
  Log = ::Log.for(self)

  def initialize(
    @path : String,
    @array = Array(MeasurementCollector::Meas::EfentoTemperature).new
  )
    @csv_paths = Dir[File.join([@path, "*.csv"])]

    Log.info { "init #{@csv_paths.size} paths" }
  end

  getter :array

  def parse
    @csv_paths.sort.each_with_index do |csv_path, i|
      Log.info { "parsing #{i + 1}/#{@csv_paths.size}: #{csv_path}" }

      parser = MeasurementCollector::Parser::EfentoTemperatureParser.new(
        path: csv_path
      )
      @array += parser.parse
      sync_logs
    end

    @array = @array.sort.uniq

    return @array
  end
end
