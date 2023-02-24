require "../src/measurement_collector"

path = "/home/olek/Dokumenty/pomiary/co2/moj_pokoj/"
collector = MeasurementCollector::Collector::Airco2ntrolCollector.new(
  path: path
)
parsed_data = collector.parse

output_path = "/home/olek/Dokumenty/pomiary/output/moj_pokoj/"
writer = MeasurementCollector::Writer::Airco2ntrolWriter.new(
  path: output_path,
  array: parsed_data
)
writer.write_per_month
