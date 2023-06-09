require "../spec_helper"

describe MeasurementCollector::Collector::Airco2ntrolCollector do
  it "load CSVs from path" do
    path = "spec/fixtures/airco2ntrol/"
    collector = MeasurementCollector::Collector::Airco2ntrolCollector.new(
      path: path,
      only_after: Time.local(2000, 1, 1)
    )
    parsed_data = collector.parse

    parsed_data.size.should eq 6
    parsed_data[0].temperature.should eq 25.7.to_f32
    parsed_data[0].relative_humidity.should eq 42.6.to_f32
    parsed_data[0].co2_level.should eq 785

    parsed_data[0].time.year.should eq 2021
    parsed_data[0].time.month.should eq 9
    parsed_data[0].time.day.should eq 2
    parsed_data[0].time.hour.should eq 20
    parsed_data[0].time.minute.should eq 18
    parsed_data[0].time.second.should eq 50
  end
end
