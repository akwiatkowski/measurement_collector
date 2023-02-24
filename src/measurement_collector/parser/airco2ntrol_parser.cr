require "./base"

class MeasurementCollector::Parser::Airco2ntrolParser < MeasurementCollector::Parser::Base
  Log = ::Log.for(self)

  def parse
    array = Array(MeasurementCollector::Meas::Airco2ntrol).new
    csv.each do |csv_iterated|
      begin
        record = MeasurementCollector::Meas::Airco2ntrol.from_hash(csv_iterated.row.to_h)
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
    @csv ||= CSV.new(csv_content, separator: ',', headers: true)
  end

  def csv_content
    read_path
  end
end
