class References < ActiveRecord::Migration
  def change
    change_table :values do |t|
      t.references :note
    end
  end
end
