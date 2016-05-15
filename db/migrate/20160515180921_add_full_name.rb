class AddFullName < ActiveRecord::Migration
  def change
    change_table :notes do |t|
      t.text :full_name
    end
  end
end
