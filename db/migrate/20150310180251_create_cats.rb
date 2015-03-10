class CreateCats < ActiveRecord::Migration
  def change
    create_table :cats do |t|
      t.date :birth_date
      t.string :color, null: false
      t.string :name
      t.string :sex, null: false
      t.text :description

      t.timestamps null: false
    end
  end
end
