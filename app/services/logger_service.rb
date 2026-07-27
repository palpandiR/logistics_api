class LoggerService

  def self.log(level, data)

    payload = {
      service: "logistics_api",
      environment: Rails.env
    }.merge(data)


    Rails.logger.public_send(
      level,
      payload.to_json
    )

  end


  def self.info(data)
    log(:info, data)
  end


  def self.warn(data)
    log(:warn, data)
  end


  def self.error(data)
    log(:error, data)
  end

end