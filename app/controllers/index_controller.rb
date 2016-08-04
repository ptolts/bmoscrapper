class IndexController < ApplicationController
  before_action :load_note, only: [:show]
  def index
    @notes = Note.q_model
  end

  def show
    stock_name = "SPY"
    @data = [
      { name: @note.name, data: @note.group_values_by_date },
      { name: stock_name, data: Stock.find_by_symbol(stock_name).map_for_note(@note) }
    ]

    @stocks = @note.holding.stocks.collect do |stock|
      { name: stock.symbol, data: stock.group_values_by_date(@note.first_date) }
    end

    @diff = difference_service.process(@data)
  end

  private

  def load_note
    @note = Note.q_model.with_holdings.find_by_id(params[:id])
  end

  def difference_service
    @difference_service = DifferenceService.new
  end
end
