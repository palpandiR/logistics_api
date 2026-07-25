module Api
  module Concerns
    module ErrorHandler

      extend ActiveSupport::Concern


      included do

        # Database Record Missing
        rescue_from ActiveRecord::RecordNotFound,
                    with: :record_not_found


        # Validation Failure
        rescue_from ActiveRecord::RecordInvalid,
                    with: :record_invalid


        # Invalid Parameters
        rescue_from ActionController::ParameterMissing,
                    with: :parameter_missing


        # JWT Errors
        rescue_from JWT::DecodeError,
                    with: :invalid_token


        # Authorization Error
        rescue_from Pundit::NotAuthorizedError,
                    with: :authorization_failed


        # Database Connection Issue
        rescue_from ActiveRecord::ConnectionNotEstablished,
                    with: :database_connection_error


        # Rate Limit Error
        rescue_from Rack::Attack::Throttle,
                    with: :rate_limit_exceeded


        # Last Safety Net
        rescue_from StandardError,
                    with: :internal_server_error

      end



      private


      # -----------------------------
      # 404 Not Found
      # -----------------------------

      def record_not_found(exception)

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



      # -----------------------------
      # 422 Validation Error
      # -----------------------------

      def record_invalid(exception)

        error_response(
          message: "Validation failed",
          errors: exception.record.errors.map do |error|

            {
              field: error.attribute,
              message: error.message
            }

          end,
          status: :unprocessable_entity
        )

      end



      # -----------------------------
      # Missing Parameters
      # -----------------------------

      def parameter_missing(exception)

        error_response(
          message: "Required parameter missing",
          errors:[
            {
              field: exception.param
            }
          ],
          status: :bad_request
        )

      end



      # -----------------------------
      # JWT Error
      # -----------------------------

      def invalid_token(exception)

        error_response(
          message: "Invalid authentication token",
          errors:[
            {
              code:"INVALID_TOKEN"
            }
          ],
          status: :unauthorized
        )

      end



      # -----------------------------
      # Authorization Error
      # -----------------------------

      def authorization_failed(exception)

        error_response(
          message:"You are not authorized",
          errors:[
            {
              code:"FORBIDDEN"
            }
          ],
          status: :forbidden
        )

      end



      # -----------------------------
      # Database Down
      # -----------------------------

      def database_connection_error(exception)

        Rails.logger.error(
          "Database connection failed: #{exception.message}"
        )


        error_response(
          message:"Service temporarily unavailable",
          errors:[
            {
              code:"DATABASE_UNAVAILABLE"
            }
          ],
          status: :service_unavailable
        )

      end



      # -----------------------------
      # Rate Limit
      # -----------------------------

      def rate_limit_exceeded(exception)

        error_response(
          message:"Too many requests",
          errors:[
            {
              code:"RATE_LIMIT_EXCEEDED"
            }
          ],
          status: :too_many_requests
        )

      end



      # -----------------------------
      # Unexpected Error
      # -----------------------------

      def internal_server_error(exception)

        Rails.logger.error(
          exception.message
        )

        Rails.logger.error(
          exception.backtrace.join("\n")
        )


        error_response(
          message:"Something went wrong",
          errors:[
            {
              code:"INTERNAL_ERROR"
            }
          ],
          status: :internal_server_error
        )

      end


    end
  end
end