class MeasurementCollector::Writer::Base
  UNIX_TIME_FLAG_DEFAULT = true

  def convert_time(time : Time, unix_time : Bool)
    if unix_time
      return time.to_unix
    else
      return time.to_s("%Y-%m-%d %H:%M:%S")
    end
  end
end
