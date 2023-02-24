require "../spec_helper"

describe MeasurementCollector::Writer::Airco2ntrolWriter do
  it "write processed data in single CSV" do
    path = "spec/fixtures/airco2ntrol/"
    collector = MeasurementCollector::Collector::Airco2ntrolCollector.new(
      path: path
    )
    parsed_data = collector.parse

    output_path = "temp/airco2ntrol_output.csv"
    writer = MeasurementCollector::Writer::Airco2ntrolWriter.new(
      path: output_path,
      array: parsed_data
    )
    writer.write

    fixture_path = "spec/fixtures/writers/airco2ntrol_writer.csv"
    fixture_text = File.read(fixture_path)
    output_text = File.read(output_path)
    output_text.should eq fixture_text
  end

  it "write processed data in CSV per month" do
    path = "spec/fixtures/airco2ntrol/"
    collector = MeasurementCollector::Collector::Airco2ntrolCollector.new(
      path: path
    )
    parsed_data = collector.parse

    # let's use the same path to check if last part is ignored
    output_path = "temp/"
    writer = MeasurementCollector::Writer::Airco2ntrolWriter.new(
      path: output_path,
      array: parsed_data
    )
    writer.write_per_month

    fixture_path = "spec/fixtures/writers/airco2ntrol_writer.csv"
    output_month_path = "temp/2021-09.csv"
    fixture_text = File.read(fixture_path)
    output_month_text = File.read(output_month_path)
    output_month_text.should eq fixture_text
  end

  it "write processed temperature data in single CSV using human readable time" do
    path = "spec/fixtures/airco2ntrol/"
    collector = MeasurementCollector::Collector::Airco2ntrolCollector.new(
      path: path
    )
    parsed_data = collector.parse

    output_path = "temp/airco2ntrol_output_human_readable.csv"
    writer = MeasurementCollector::Writer::Airco2ntrolWriter.new(
      path: output_path,
      array: parsed_data,
      unix_time: false
    )
    writer.write

    fixture_path = "spec/fixtures/writers/airco2ntrol_writer_human_readable.csv"
    fixture_text = File.read(fixture_path)
    output_text = File.read(output_path)
    output_text.should eq fixture_text
  end
end
