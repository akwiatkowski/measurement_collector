require "./base"

class MeasurementCollector::Parser::EfentoTemperatureParser < MeasurementCollector::Parser::Base
  Log = ::Log.for(self)

  def parse
    array = Array(MeasurementCollector::Meas::Temperature).new
    csv.each do |csv_iterated|
      begin
        record = MeasurementCollector::Meas::Temperature.from_efento_csv(csv_iterated.row.to_h)
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
    @csv ||= CSV.new(csv_content, separator: ';', headers: true)
  end

  def csv_content
    new_line_index = read_path.index('\n')
    return "" if new_line_index.nil?
    read_path[(new_line_index.not_nil! + 1)..-1]
  end
end
