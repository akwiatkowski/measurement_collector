struct MeasurementCollector::Meas::Temperature
  def initialize(@time : Time, @temperature : Float32)
  end

  getter :time, :temperature

  def self.from_efento_csv(csv_row)
    time = Time.parse_local(
      csv_row["Data"],
      "%Y-%m-%d %H:%M:%S"
    )
    temperature = csv_row["Temperatura"].to_s.to_f32

    new(time: time, temperature: temperature)
  end
end
