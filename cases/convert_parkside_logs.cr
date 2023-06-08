require "./log_config"
require "../src/measurement_collector"

Log.info { "start script " }

path = "/home/olek/Dokumenty/pomiary/temperatura/rolna_ogrodek/"
collector = MeasurementCollector::Collector::ParksideCollector.new(
  path: path
)
parsed_data = collector.parse

output_path = "/home/olek/Dokumenty/pomiary/output/rolna_ogrodek/"
writer = MeasurementCollector::Writer::TemperatureHumidityWriter.new(
  path: output_path,
  array: parsed_data,
  unix_time: false
)
writer.write_per_month
