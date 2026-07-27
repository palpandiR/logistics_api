module Customers
  class CreateService

    def initialize(params:, current_user:)
      @params = params
      @current_user = current_user
    end

    def call
      ActiveRecord::Base.transaction do

        customer = Customer.create!(@params)

        # Future:
        # AuditLog.create!
        # CustomerCreatedJob.perform_later(customer.id)

        customer

      end
    end

    private

    attr_reader :params,
                :current_user

  end
end