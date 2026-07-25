module Api
  module V2
    class HealthController < BaseController
      def index
        render json: {
          status: "ok",
          version: "v2"
        }
      end
    end
  end
end