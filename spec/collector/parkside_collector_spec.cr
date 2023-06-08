require "../spec_helper"

describe MeasurementCollector::Collector::ParksideCollector do
  it "load CSVs from path" do
    path = "spec/fixtures/parkside/"
    collector = MeasurementCollector::Collector::ParksideCollector.new(
      path: path
    )
    parsed_data = collector.parse

    parsed_data.size.should eq 13
    parsed_data[0].temperature.should eq 30.3.to_f32
    parsed_data[0].relative_humidity.should eq 49.7.to_f32

    parsed_data[0].time.year.should eq 2023
    parsed_data[0].time.month.should eq 6
    parsed_data[0].time.day.should eq 7
    parsed_data[0].time.hour.should eq 19
    parsed_data[0].time.minute.should eq 17
    parsed_data[0].time.second.should eq 28
  end
end
