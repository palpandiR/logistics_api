class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email, null:false

      t.string :password_digest, null:false

      t.string :role, default:"customer"

      t.timestamps
    end
  end
end
