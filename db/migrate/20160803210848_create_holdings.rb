class CreateHoldings < ActiveRecord::Migration
  def change
    create_table :holdings do |t|
      t.references :note
      t.date  :month
      t.timestamps null: false
    end

    create_join_table :holdings, :stocks
  end
end
