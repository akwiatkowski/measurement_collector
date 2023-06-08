struct MeasurementCollector::Meas::TemperatureHumidity
  Log = ::Log.for(self)

  def initialize(
    @time : Time,
    @temperature : Float32,
    @relative_humidity : Float32
  )
  end

  getter :time, :temperature, :relative_humidity

  def self.from_parkside_csv(csv_row)
    time = Time.parse_local(
      csv_row["YY/MM/DD Time"],
      "%Y/%m/%d  %H:%M:%S"
    )

    temperature = csv_row["Temp \xA1\xE6"].to_s.to_f32
    relative_humidity = csv_row["Humidity %"].to_s.to_f32

    new(
      time: time,
      temperature: temperature,
      relative_humidity: relative_humidity
    )
  end

  def <=>(other)
    self.time <=> other.time
  end
end
