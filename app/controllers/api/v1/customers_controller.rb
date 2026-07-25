module Api
  module V1

    class CustomersController < BaseController

      def show

        customer = Customer.find(params[:id])

        success_response(
          data: customer,
          message: "Customer fetched successfully"
        )

      end

    end

  end
end