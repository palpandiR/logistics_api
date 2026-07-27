class CustomerSerializer < Blueprinter::Base
  identifier :id

  fields :name, :email, :phone, :status

  field :created_at do |customer|
    customer.created_at.iso8601
  end
end