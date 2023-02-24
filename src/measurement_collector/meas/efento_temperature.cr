struct MeasurementCollector::Meas::EfentoTemperature
  Log = ::Log.for(self)

  def initialize(@time : Time, @temperature : Float32)
  end

  getter :time, :temperature

  def self.from_csv(csv_row)
    time = Time.parse_local(
      csv_row["Data"],
      "%Y-%m-%d %H:%M:%S"
    ).at_beginning_of_minute # ignore seconds because of how efento buffer works

    temperature = csv_row["Temperatura"].to_s.to_f32

    new(time: time, temperature: temperature)
  end

  def <=>(other)
    self.time <=> other.time
  end
end
