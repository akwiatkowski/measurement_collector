require "./log_config"
require "../src/measurement_collector"

Log.info { "start script " }

path = "/home/olek/Dokumenty/pomiary/temperatura/dzialka_garaz_polnoc/"
collector = MeasurementCollector::Collector::EfentoTemperatureCollector.new(
  path: path
)
parsed_data = collector.parse

output_path = "/home/olek/Dokumenty/pomiary/output/dzialka/"
writer = MeasurementCollector::Writer::TemperatureWriter.new(
  path: output_path,
  array: parsed_data,
  unix_time: false
)
writer.write_per_month
