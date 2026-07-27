module Middleware
  class ApiRequestLogger

    def initialize(app)
      @app = app
    end

    def call(env)

      start_time = Time.current

      request = ActionDispatch::Request.new(env)


      begin

        status, headers, response = @app.call(env)

      rescue => exception

        Rails.logger.error(
          {
            service: "logistics_api",
            request_id: request.request_id,
            exception: exception.class.name,
            message: exception.message
          }.to_json
        )

        raise exception

      end


      duration =
        ((Time.current - start_time) * 1000).round(2)


      Rails.logger.info(
        {
          service: "logistics_api",
          request_id: request.request_id,
          method: request.request_method,
          path: request.path,
          status: status,
          duration_ms: duration
        }.to_json
      )


      [status, headers, response]

    end

  end
end

def call(env)

  start_time = Time.current

  request = ActionDispatch::Request.new(env)


  begin

    status, headers, response = @app.call(env)

  rescue => exception

    Rails.logger.error(
      {
        service: "logistics_api",
        request_id: request.request_id,
        exception: exception.class.name,
        message: exception.message
      }.to_json
    )

    raise exception

  end


  duration =
    ((Time.current - start_time) * 1000).round(2)


  Rails.logger.info(
    {
      service: "logistics_api",
      request_id: request.request_id,
      method: request.request_method,
      path: request.path,
      status: status,
      duration_ms: duration
    }.to_json
  )


  [status, headers, response]

end