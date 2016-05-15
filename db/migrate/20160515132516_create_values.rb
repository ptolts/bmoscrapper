class CreateValues < ActiveRecord::Migration
  def change
    create_table :values do |t|
      t.decimal :price
      t.date    :date
      t.timestamps null: false
    end
  end
end
