require "../spec_helper"

describe MeasurementCollector::Parser::EfentoTemperature do
  it "works" do
    path = "spec/fixtures/efento_temperature.csv"
    parser = MeasurementCollector::Parser::EfentoTemperature.new(
      path: path
    )
  end
end
