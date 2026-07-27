module Api
 module V1
  class AuthenticationController < BaseController
    skip_before_action :authenticate_user!


    def login
      user =
        User.find_by(
          email: params[:email]
        )


      if user &&
         user.authenticate(params[:password])


        token =
          JwtService.encode(
            user_id: user.id
          )


        success_response(

          data: {
            token: token
          },

          message: "Login successful"

        )


      else


        error_response(

          message: "Invalid email or password",

          status: :unauthorized

        )


      end
    end
  end
 end
end
