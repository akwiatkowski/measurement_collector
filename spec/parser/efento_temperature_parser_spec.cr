require "../spec_helper"

describe MeasurementCollector::Parser::EfentoTemperatureParser do
  it "parse fixture csv" do
    path = "spec/fixtures/efento_temperature/efento_temperature.csv"
    parser = MeasurementCollector::Parser::EfentoTemperatureParser.new(
      path: path
    )
    parsed_data = parser.parse

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
