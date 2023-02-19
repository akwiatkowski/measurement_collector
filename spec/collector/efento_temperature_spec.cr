require "../spec_helper"

describe MeasurementCollector::Parser::EfentoTemperature do
  it "load CSVs from path" do
    path = "spec/fixtures/efento_temperature/"
    collector = MeasurementCollector::Collector::EfentoTemperature.new(
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
    parsed_data[0].time.second.should eq 21
  end
end
