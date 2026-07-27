class JsonLogFormatter < Logger::Formatter

  def call(
    severity,
    time,
    progname,
    msg
  )

    log_data = {
      timestamp: time.utc.iso8601,
      level: severity
    }


    case msg

    when String

      begin

        parsed_message = JSON.parse(msg)

        if parsed_message.is_a?(Hash)
          log_data.merge!(parsed_message)
        else
          log_data[:message] = parsed_message
        end


      rescue JSON::ParserError

        log_data[:message] = msg

      end


    when Hash

      log_data.merge!(msg)


    else

      log_data[:message] = msg.to_s

    end


    log_data.to_json + "\n"

  end

end