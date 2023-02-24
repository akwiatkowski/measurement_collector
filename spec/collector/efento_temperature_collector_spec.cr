require "../spec_helper"

describe MeasurementCollector::Collector::EfentoTemperatureCollector do
  it "load CSVs from path" do
    path = "spec/fixtures/efento_temperature/"
    collector = MeasurementCollector::Collector::EfentoTemperatureCollector.new(
      path: path
    )
    parsed_data = collector.parse

    parsed_data.size.should eq 14
    parsed_data[0].temperature.should eq 10.4.to_f32

    parsed_data[0].time.year.should eq 2022
    parsed_data[0].time.month.should eq 11
    parsed_data[0].time.day.should eq 12
    parsed_data[0].time.hour.should eq 14
    parsed_data[0].time.minute.should eq 26
    # because of how efento generate CSV (dynamically) using data buffer
    # it's better to not parse seconds. I'll set always seconds 0 zero.
    parsed_data[0].time.second.should eq 0
  end

  it "load CSVs from path and ignore duplicated values with seconds diff" do
    path = "spec/fixtures/efento_temperature_ignore_seconds/"
    collector = MeasurementCollector::Collector::EfentoTemperatureCollector.new(
      path: path
    )
    parsed_data = collector.parse

    parsed_data.size.should eq 14
    parsed_data[0].temperature.should eq 10.4.to_f32

    parsed_data[0].time.year.should eq 2022
    parsed_data[0].time.month.should eq 11
    parsed_data[0].time.day.should eq 12
    parsed_data[0].time.hour.should eq 14
    parsed_data[0].time.minute.should eq 26
    # because of how efento generate CSV (dynamically) using data buffer
    # it's better to not parse seconds. I'll set always seconds 0 zero.
    parsed_data[0].time.second.should eq 0
  end
end
