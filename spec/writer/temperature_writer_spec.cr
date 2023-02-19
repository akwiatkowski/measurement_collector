require "../spec_helper"

describe MeasurementCollector::Writer::TemperatureWriter do
  it "load CSVs from path" do
    path = "spec/fixtures/efento_temperature/"
    collector = MeasurementCollector::Collector::EfentoTemperature.new(
      path: path
    )
    parsed_data = collector.parse

    output_path = "temp/temperature_output.csv"
    writer = MeasurementCollector::Writer::TemperatureWriter.new(
      path: output_path,
      array: parsed_data
    )
    writer.write
  end
end
