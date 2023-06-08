require "./base"

class MeasurementCollector::Parser::ParksideParser < MeasurementCollector::Parser::Base
  Log = ::Log.for(self)

  def parse
    array = Array(MeasurementCollector::Meas::TemperatureHumidity).new
    csv.each do |csv_iterated|
      begin
        record = MeasurementCollector::Meas::TemperatureHumidity.from_parkside_csv(
          csv_iterated.row.to_h
        )
        array << record
      rescue Time::Format::Error
        Log.error { "parse: #{csv.row.to_h.inspect} invalid time format" }
      rescue KeyError
        Log.error { "parse: #{csv.row.to_h.inspect} invalid record" }
      end
    end
    return array
  end

  def csv
    @csv ||= CSV.new(read_path, separator: ',', headers: true)
  end
end
