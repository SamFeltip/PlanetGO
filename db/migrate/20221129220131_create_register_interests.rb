class CreateRegisterInterests < ActiveRecord::Migration[7.0]
  def change
    create_table :register_interests do |t|
      t.string :email

      t.timestamps
    end
  end
end
