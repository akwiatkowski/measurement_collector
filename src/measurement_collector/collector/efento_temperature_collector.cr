class MeasurementCollector::Collector::EfentoTemperatureCollector
  Log = ::Log.for(self)

  def initialize(
    @path : String,
    @array = Array(MeasurementCollector::Meas::Temperature).new
  )
    @csv_paths = Dir[File.join([@path, "*.csv"])]

    Log.info { "init #{@csv_paths}" }
  end

  getter :array

  def parse
    @csv_paths.each do |csv_path|
      Log.debug { "parsing #{csv_path}" }

      parser = MeasurementCollector::Parser::EfentoTemperatureParser.new(
        path: csv_path
      )
      @array += parser.parse
    end

    @array = @array.sort.uniq

    return @array
  end
end
