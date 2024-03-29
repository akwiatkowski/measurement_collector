class MeasurementCollector::Writer::TemperatureWriter < MeasurementCollector::Writer::Base
  Log = ::Log.for(self)

  def initialize(
    @path : String,
    @array : Array(MeasurementCollector::Meas::EfentoTemperature),
    @unix_time = UNIX_TIME_FLAG_DEFAULT
  )
    @sorted_array = @array.uniq { |r| r.time }.sort.as(
      Array(MeasurementCollector::Meas::EfentoTemperature)
    )

    Log.debug { "init #{@path} #{@sorted_array.size} records" }
  end

  getter :array, :sorted_array

  def write
    File.open(@path, "w") do |file|
      file.puts "time;temperature"
      CSV.build(
        io: file,
        separator: ';',
        quote_char: '"'
      ) do |csv|
        @sorted_array.each do |temperature|
          csv.row convert_time(temperature.time, @unix_time), temperature.temperature
        end
      end
    end

    Log.info { "wrote #{@path} #{@sorted_array.size} records" }
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

      month_array = @sorted_array.select do |temperature|
        temperature.time.year == time.year && temperature.time.month == time.month
      end

      # TODO: refactor to have one place which execute writing monthly processed data
      Log.info { "writing monthly CSV #{month_filename} with #{month_array.size} records" }
      sync_logs

      writer = MeasurementCollector::Writer::TemperatureWriter.new(
        path: path_month,
        array: month_array,
        unix_time: @unix_time
      )
      writer.write

      time = time.shift(months: 1)
    end
  end
end
