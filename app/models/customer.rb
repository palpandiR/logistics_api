class Customer < ApplicationRecord
  enum :status, {
    active: 0,
    inactive: 1
  }

  validates :name,
            presence: true,
            length: { maximum: 100 }

  validates :email,
            presence: true,
            uniqueness: true,
            format: {
              with: URI::MailTo::EMAIL_REGEXP
            }

  validates :phone,
            length: {
              maximum: 20
            },
            allow_blank: true
end
