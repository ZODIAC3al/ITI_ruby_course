require 'time'

module Logger
  def log_info(message)
    log("info", message)
  end

  def log_warning(message)
    log("warning", message)
  end

  def log_error(message)
    log("error", message)
  end

  private

  def log(log_type, message)
    timestamp = Time.now.iso8601
    File.open("app.log", "a") do |file|
      file.puts("#{timestamp} -- #{log_type} -- #{message}")
    end
  end
end
