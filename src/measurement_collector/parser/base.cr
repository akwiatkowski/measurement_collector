require "csv"

class MeasurementCollector::Parser::Base
  Log = ::Log.for(self)

  def initialize(@path : String)
    Log.info { "init #{@path}" }
  end

  def parse
    raise NotImplementedError
  end

  def read_path
    @read_path ||= File.read(@path)
  end
end
