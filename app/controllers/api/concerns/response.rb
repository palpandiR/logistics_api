module Api
  module Concerns
    module Response

      def success_response(
        data: {},
        message: "Success",
        meta: {}
      )

        render json: {
          success: true,
          message: message,
          data: data,
          errors: [],
          meta: meta
        }

      end


      def error_response(
        message: "Error",
        errors: [],
        status: :unprocessable_entity
      )

        render json: {
          success: false,
          message: message,
          data: {},
          errors: errors,
          meta: {}
        },
        status: status

      end

    end
  end
end