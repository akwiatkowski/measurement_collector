class MeasurementCollector::Collector::Airco2ntrolCollector
  # Log = ::Log.for(self)

  def initialize(
    @path : String,
    @array = Array(MeasurementCollector::Meas::Airco2ntrol).new,
    @only_after = (Time.local - 3.months).at_beginning_of_month
  )
    @csv_paths = Dir[File.join([@path, "*.csv"])]

    Log.info { "init #{@csv_paths.size} paths" }
  end

  getter :array

  def parse
    Log.info { "start parsing" }

    @csv_paths.sort.each_with_index do |csv_path, i|
      Log.info { "parsing #{i + 1}/#{@csv_paths.size}: #{csv_path}" }

      parser = MeasurementCollector::Parser::Airco2ntrolParser.new(
        path: csv_path
      )
      @array += parser.parse.select { |meas| meas.time >= @only_after }
      sync_logs
    end

    @array = @array.sort.uniq

    return @array
  end
end
