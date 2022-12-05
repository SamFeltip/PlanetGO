class CreateRegisterInterests < ActiveRecord::Migration[7.0]
  def change
    create_table :register_interests do |t|
      t.string :email
      t.string :pricing_id

      t.timestamps
    end
  end
end
