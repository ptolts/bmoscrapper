class AddIndexes < ActiveRecord::Migration
  def change
    add_index(:values, :note_id)
  end
end
