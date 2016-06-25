# == Schema Information
#
# Table name: stocks
#
#  id         :integer          not null, primary key
#  name       :text
#  symbol     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class StockTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
