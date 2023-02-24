class MeasurementCollector::Writer::Airco2ntrolWriter < MeasurementCollector::Writer::Base
  Log = ::Log.for(self)

  def initialize(
    @path : String,
    @array : Array(MeasurementCollector::Meas::Airco2ntrol),
    @unix_time = UNIX_TIME_FLAG_DEFAULT
  )
    @sorted_array = @array.sort.uniq

    Log.debug { "init #{@path} #{@sorted_array.size} records" }
  end

  getter :array, :sorted_array

  def write
    Log.info { "write #{@path} #{@sorted_array.size} records" }

    File.open(@path, "w") do |file|
      file.puts "time;temperature;relative_humidity;co2_level"
      CSV.build(
        io: file,
        separator: ';',
        quote_char: '"'
      ) do |csv|
        @sorted_array.each do |airco2ntrol|
          csv.row convert_time(airco2ntrol.time, @unix_time), airco2ntrol.temperature,
            airco2ntrol.relative_humidity, airco2ntrol.co2_level
        end
      end
    end
  end

  def write_per_month
    Log.debug { "starting for multiple months #{@sorted_array.size} records" }

    # no data -> do nothing
    return if @sorted_array.size == 0

    time_from = @sorted_array.first.time
    time_to = @sorted_array.last.time
    time = time_from

    while time <= time_to
      month_filename = time.to_s("%Y-%m.csv")
      path_month = File.join([@path, month_filename])

      month_array = @sorted_array.select do |airco2ntrol|
        airco2ntrol.time.year == time.year && airco2ntrol.time.month == time.month
      end

      writer = MeasurementCollector::Writer::Airco2ntrolWriter.new(
        path: path_month,
        array: month_array,
        unix_time: @unix_time
      )
      writer.write

      time = time.shift(months: 1)
    end
  end
end
