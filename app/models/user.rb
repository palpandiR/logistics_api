class User < ApplicationRecord

  has_secure_password

  validates :email,
            presence:true,
            uniqueness:true


  enum :role,
       {
        customer:"customer",
        admin:"admin"
       }

end