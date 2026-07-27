module Api
  module V1
    class CustomersController < Api::BaseController

      def create
        authorize Customer
        customer = Customers::CreateService.new(
          params: customer_params,
          current_user: current_user
        ).call
        
        success_response(
          data: CustomerSerializer.render_as_hash(customer),
          message: "Customer created successfully",
          status: :created
        )
      end

      def show
        customer = Customer.find(params[:id])

        authorize customer
      
        success_response(
          data: CustomerSerializer.render_as_hash(customer),
          message: "Customer fetched successfully"
        )
      end
      
      def test_error
        raise "Testing middleware exception logging"
      end

      private

      def customer_params
        params.require(:customer)
              .permit(:name, :email, :phone, :status)
      end

    end
  end
end
