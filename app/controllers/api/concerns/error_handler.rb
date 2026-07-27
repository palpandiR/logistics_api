module Api
  module Concerns
    module ErrorHandler

      extend ActiveSupport::Concern


      included do

        # Generic Error
        # Register FIRST because Rails searches reverse order
        rescue_from StandardError,
                    with: :internal_server_error


        # Authentication
        rescue_from AuthenticationError,
                    with: :authentication_failed


        # JWT
        rescue_from JWT::DecodeError,
                    with: :invalid_token


        # Authorization
        rescue_from Pundit::NotAuthorizedError,
                    with: :authorization_failed


        # ActiveRecord
        rescue_from ActiveRecord::RecordNotFound,
                    with: :record_not_found


        rescue_from ActiveRecord::RecordInvalid,
                    with: :record_invalid


        # Parameters
        rescue_from ActionController::ParameterMissing,
                    with: :parameter_missing


        # Database
        rescue_from ActiveRecord::ConnectionNotEstablished,
                    with: :database_connection_error


        # Rate Limit
        rescue_from Rack::Attack::Throttle,
                    with: :rate_limit_exceeded

      end



      private



      # --------------------------------
      # 401 Authentication Error
      # --------------------------------

      def authentication_failed(exception)

        log_exception(
          exception,
          level: :warn
        )


        error_response(
          message: exception.message,
          errors: [
            {
              code: "UNAUTHORIZED"
            }
          ],
          status: :unauthorized
        )

      end




      # --------------------------------
      # 401 Invalid JWT
      # --------------------------------

      def invalid_token(exception)

        log_exception(
          exception,
          level: :warn
        )


        error_response(
          message: "Invalid authentication token",
          errors: [
            {
              code: "INVALID_TOKEN"
            }
          ],
          status: :unauthorized
        )

      end




      # --------------------------------
      # 403 Forbidden
      # --------------------------------

      def authorization_failed(exception)

        log_exception(
          exception,
          level: :warn
        )


        error_response(
          message: "You are not authorized",
          errors: [
            {
              code: "FORBIDDEN"
            }
          ],
          status: :forbidden
        )

      end




      # --------------------------------
      # 404 Not Found
      # --------------------------------

      def record_not_found(exception)

        log_exception(
          exception,
          level: :warn
        )


        error_response(
          message: "Resource not found",
          errors: [
            {
              code: "NOT_FOUND",
              detail: exception.message
            }
          ],
          status: :not_found
        )

      end




      # --------------------------------
      # 422 Validation Error
      # --------------------------------

      def record_invalid(exception)


        log_exception(
          exception,
          level: :warn,
          extra: {
            validation_errors:
              exception.record.errors.full_messages
          }
        )


        error_response(
          message: "Validation failed",

          errors:
            exception.record.errors.map do |error|

              {
                field: error.attribute.to_s,
                message: error.message
              }

            end,

          status: :unprocessable_entity
        )

      end




      # --------------------------------
      # 400 Missing Parameter
      # --------------------------------

      def parameter_missing(exception)

        log_exception(
          exception,
          level: :warn
        )


        error_response(
          message: "Required parameter missing",

          errors: [
            {
              field: exception.param
            }
          ],

          status: :bad_request
        )

      end




      # --------------------------------
      # 503 Database Error
      # --------------------------------

      def database_connection_error(exception)

        log_exception(
          exception,
          level: :error
        )


        error_response(
          message: "Service temporarily unavailable",

          errors: [
            {
              code: "DATABASE_UNAVAILABLE"
            }
          ],

          status: :service_unavailable
        )

      end




      # --------------------------------
      # 429 Rate Limit
      # --------------------------------

      def rate_limit_exceeded(exception)

        log_exception(
          exception,
          level: :warn
        )


        error_response(
          message: "Too many requests",

          errors: [
            {
              code: "RATE_LIMIT_EXCEEDED"
            }
          ],

          status: :too_many_requests
        )

      end




      # --------------------------------
      # 500 Internal Error
      # --------------------------------

      def internal_server_error(exception)

        log_exception(
          exception,
          level: :error,
          extra: {
            backtrace:
              exception.backtrace&.first(5)
          }
        )


        error_response(
          message: "Something went wrong",

          errors: [
            {
              code: "INTERNAL_ERROR"
            }
          ],

          status: :internal_server_error
        )

      end




      # --------------------------------
      # Common Exception Logger
      # --------------------------------

      def log_exception(exception, level: :error, extra: {})

        user_id = nil

        if respond_to?(:current_user)
          user_id = current_user&.id
        end


        log_data = {

          request_id: request.request_id,

          error_type: exception.class.name,

          message: exception.message,

          path: request.path,

          method: request.request_method,

          user_id: user_id

        }.merge(extra)


        LoggerService.public_send(
          level,
          log_data
        )

      end


    end
  end
end