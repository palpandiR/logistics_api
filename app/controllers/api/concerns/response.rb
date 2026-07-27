module Api
  module Concerns
    module Response

      extend ActiveSupport::Concern

      def success_response(
        data: {},
        message: "Success",
        meta: {},
        status: :ok
      )
        render json: {
          success: true,
          message: message,
          data: data,
          errors: [],
          meta: meta
        }, status: status
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
        }, status: status
      end

    end
  end
end