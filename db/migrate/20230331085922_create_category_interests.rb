class CreateCategoryInterests < ActiveRecord::Migration[7.0]
  def change
    create_table :category_interests do |t|

      t.timestamps
    end
  end
end
