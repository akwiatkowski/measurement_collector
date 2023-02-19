class MeasurementCollector::Writer::TemperatureWriter
  def initialize(
    @path : String,
    @array : Array(MeasurementCollector::Meas::Temperature)
  )
  end

  getter :array

  def sorted_array
    return @array.sort.uniq
  end

  def write
    File.open(@path, "w") do |file|
      file.puts "time;temperature"
      CSV.build(
        io: file,
        separator: ';',
        quote_char: '"'
      ) do |csv|
        sorted_array.each do |temperature|
          csv.row temperature.time.to_unix, temperature.temperature
        end
      end
    end
  end

  def write_per_month
    # no data -> do nothing
    return if sorted_array.size == 0

    base_path = File.dirname(@path)

    time_from = sorted_array.first.time
    time_to = sorted_array.last.time
    time = time_from

    while time <= time_to
      month_filename = time.to_s("%Y-%m.csv")
      path_month = File.join([base_path, month_filename])

      month_array = sorted_array.select do |temperature|
        temperature.time.year == time.year && temperature.time.month == time.month
      end

      writer = MeasurementCollector::Writer::TemperatureWriter.new(
        path: path_month,
        array: month_array
      )
      writer.write

      time = time.shift(months: 1)
    end
  end
end
