class MeasurementCollector::Writer::Airco2ntrolWriter < MeasurementCollector::Writer::Base
  Log = ::Log.for(self)

  def initialize(
    @path : String,
    @array : Array(MeasurementCollector::Meas::Airco2ntrol),
    @unix_time = UNIX_TIME_FLAG_DEFAULT,
    @only_after = (Time.local - 3.months).at_beginning_of_month
  )
    @sorted_array = @array.uniq { |r| r.time }.sort.as(
      Array(MeasurementCollector::Meas::Airco2ntrol)
    )

    Log.debug { "init #{@path} #{@sorted_array.size} records" }
  end

  getter :array, :sorted_array

  def write
    Log.info { "write #{@path} #{@sorted_array.size} records" }

    File.open(@path, "w") do |file|
      file.puts "time;temperature;relative_humidity;co2_level"
      CSV.build(
        io: file,
        separator: ';',
        quote_char: '"'
      ) do |csv|
        @sorted_array.each_with_index do |airco2ntrol, i|
          # TODO: add logger debug with index
          csv.row convert_time(airco2ntrol.time, @unix_time), airco2ntrol.temperature,
            airco2ntrol.relative_humidity, airco2ntrol.co2_level
        end
      end
    end
  end

  def write_per_month
    only_after_begin_of_month = @only_after.at_beginning_of_month
    Log.debug { "starting for multiple months #{@sorted_array.size} records" }
    Log.debug { "filter only after #{only_after_begin_of_month}" }

    # no data -> do nothing
    return if @sorted_array.size == 0

    time_from = @sorted_array.first.time
    time_to = @sorted_array.last.time
    time = time_from

    # different approach on splitting
    meas_hash = Hash(String, Array(MeasurementCollector::Meas::Airco2ntrol)).new

    @sorted_array.each do |meas|
      # we have a lot of data and it's better to just ignore some old
      # measurements which should be already processed
      next if meas.time < only_after_begin_of_month

      month_prefix = meas.time.to_s("%Y-%m")
      if meas_hash[month_prefix]?.nil?
        meas_hash[month_prefix] = Array(MeasurementCollector::Meas::Airco2ntrol).new
      end

      meas_hash[month_prefix] << meas

      if (meas_hash[month_prefix].size % 50_000 == 0)
        Log.info { "separation #{month_prefix} with #{meas_hash[month_prefix].size} records" }
      end
    end

    meas_hash.keys.each do |month_prefix|
      month_filename = "#{month_prefix}.csv"
      path_month = File.join([@path, month_filename])

      month_array = meas_hash[month_prefix]

      # TODO: refactor to have one place which execute writing monthly processed data
      Log.info { "writing monthly CSV #{month_filename} with #{month_array.size} records" }
      sync_logs

      writer = MeasurementCollector::Writer::Airco2ntrolWriter.new(
        path: path_month,
        array: month_array,
        unix_time: @unix_time
      )
      writer.write
    end
  end
end
