class AddNoteId < ActiveRecord::Migration
  def change
    change_table :notes do |t|
      t.integer :note_id
    end
  end
end
