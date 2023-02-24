Log.setup do |c|
  backend = Log::IOBackend.new(
    io: STDOUT,
    formatter: Log::ShortFormat,
    dispatcher: Log::DispatchMode::Async,
  )
  c.bind "*", :debug, backend
  c.bind "*", :info, backend
end
