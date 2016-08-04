require 'test_helper'

class HoldingTest < ActiveSupport::TestCase
  test "holding relations" do
    holding = Holding.create
    stocks = (0..4).collect{ Stock.create }
    holding.stocks = stocks
    note = Note.create
    note.holdings << holding
  end

  test "first holding" do
    # ActiveRecord::Base.logger = Logger.new(STDOUT)
    note = Note.create(name: 'test')
    iterations = 3
    iterations.times do
      holding = Holding.create
      stocks = (0..4).collect{ Stock.create }
      holding.stocks = stocks
      note.holdings << holding
    end
    assert_equal iterations, note.holdings.count
    assert_equal note.holding.nil?, false
  end
end
