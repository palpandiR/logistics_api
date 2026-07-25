module Api
  module V1
    class HealthController < BaseController

      def index

        success_response(
          data:{
            status:"ok",
            version:"v1"
          },
          message:"API is healthy"
        )

      end

    end
  end
end