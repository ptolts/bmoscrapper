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
  end

  private

  def load_note
    @note = Note.q_model.find_by_id(params[:id])
  end
end
