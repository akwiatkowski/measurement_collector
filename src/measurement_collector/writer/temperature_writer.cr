class MeasurementCollector::Writer::TemperatureWriter
  def initialize(
    @path : String,
    @array : Array(MeasurementCollector::Meas::Temperature)
  )
  end

  getter :array

  def write
    File.open(@path, "w") do |file|
      file.puts "time;temperature"
      CSV.build(
        io: file,
        separator: ';',
        quote_char: '"'
      ) do |csv|
        @array.each do |temperature|
          csv.row temperature.time.to_unix, temperature.temperature
        end
      end
    end
  end
end
