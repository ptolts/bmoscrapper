# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  name       :text
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  note_id    :integer
#  full_name  :text
#

require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
