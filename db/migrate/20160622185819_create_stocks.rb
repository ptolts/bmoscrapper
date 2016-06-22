class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.text :name
      t.text :symbol
      t.timestamps null: false
    end

    change_table :values do |t|
      t.references :stock, index: true
    end
  end
end
