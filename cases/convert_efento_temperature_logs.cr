require "../src/measurement_collector"

path = "/home/olek/Dokumenty/pomiary/temperatura/dzialka_garaz_polnoc/"
collector = MeasurementCollector::Collector::EfentoTemperature.new(
  path: path
)
parsed_data = collector.parse

output_path = "/home/olek/Dokumenty/pomiary/output/dzialka/"
writer = MeasurementCollector::Writer::TemperatureWriter.new(
  path: output_path,
  array: parsed_data
)
writer.write_per_month
