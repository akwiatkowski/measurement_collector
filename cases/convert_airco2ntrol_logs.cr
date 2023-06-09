require "./log_config"
require "../src/measurement_collector"

Log.info { "start script " }

path = "/home/olek/Dokumenty/pomiary/co2/moj_pokoj/"
only_after = (Time.local - 2.months).at_beginning_of_month

collector = MeasurementCollector::Collector::Airco2ntrolCollector.new(
  path: path,
  only_after: only_after
)
parsed_data = collector.parse

output_path = "/home/olek/Dokumenty/pomiary/output/moj_pokoj/"
writer = MeasurementCollector::Writer::Airco2ntrolWriter.new(
  path: output_path,
  array: parsed_data,
  unix_time: false
)
writer.write_per_month(
  only_after: only_after
)
