# == Schema Information
#
# Table name: values
#
#  id         :integer          not null, primary key
#  price      :decimal(, )
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  note_id    :integer
#
# Indexes
#
#  index_values_on_note_id  (note_id)
#

require 'test_helper'

class ValueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
