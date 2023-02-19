require "csv"

class MeasurementCollector::Parser::Base
  def initialize(@path : String)
    @csv_content = ""
  end

  def parse
    raise NotImplementedError
  end

  def read_path
    @read_path ||= File.read(@path)
  end
end
