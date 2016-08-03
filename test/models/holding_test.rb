require 'test_helper'

class HoldingTest < ActiveSupport::TestCase
  test "the truth" do
    holding = Holding.create
    stocks = (0..4).collect{ Stock.create }
    holding.stocks = stocks
    note = Note.create
    note.holdings << holding
  end
end
