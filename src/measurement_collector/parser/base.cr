class MeasurementCollector::Parser::Base
  def initialize(@path : String)
  end

  def parse
    raise NotImplementedError
  end
end
