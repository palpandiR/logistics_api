module Api
  module Concerns
    module Authentication
      extend ActiveSupport::Concern


      included do
        before_action :authenticate_user!
      end

      private
      def authenticate_user!
        header = request.headers["Authorization"]
        if header.blank?
          raise AuthenticationError, "Authorization header is missing"
        end
        token = header.split.last
        payload = JwtService.decode(token)
        @current_user = User.find(payload[:user_id])
      end



      def current_user
        @current_user
      end
    end
  end
end
