module Api
  module V1
    class CustomersController < BaseController
      def show
        binding.pry
        customer = Customer.find(params[:id])

        # authorize customer

        success_response(
          data: customer,
          message: "Customer fetched successfully"
        )
      end
    end
  end
end
