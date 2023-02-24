struct MeasurementCollector::Meas::Airco2ntrol
  Log = ::Log.for(self)

  def initialize(
    @time : Time,
    @co2_level : Int32,
    @temperature : Float32,
    @relative_humidity : Float32
  )
  end

  getter :time, :temperature, :co2_level, :relative_humidity

  def self.from_hash(csv_row_hash)
    time = Time.parse_local(
      csv_row_hash["M_D_YYYY"].to_s.strip + " " + csv_row_hash["TIME[HH:mm:ss]"].to_s.strip,
      "%m/%d/%Y %H:%M:%S"
    )
    temperature = csv_row_hash["Temp[C]"].to_s.to_f32
    co2_level = csv_row_hash["CO2[ppm]"].to_s.to_i
    relative_humidity = csv_row_hash["RH[%]"].to_s.to_f32

    new(
      time: time,
      temperature: temperature,
      co2_level: co2_level,
      relative_humidity: relative_humidity,
    )
  end

  def <=>(other)
    self.time <=> other.time
  end
end
