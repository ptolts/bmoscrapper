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

class Stock < ActiveRecord::Base
  has_many :values
  has_many :holdings_stocks

  def map_for_note(note)
    starting_day = note.values.first.date
    starting_value = 100
    array = {}
    values.where('date > ?', starting_day).each_cons(2) do |yesterday, today|
      change = ((today.price - yesterday.price) / yesterday.price)
      difference = starting_value * change
      starting_value = (starting_value + difference).round(5)
      array[today.date] = starting_value
    end
    array
  end

  def symbol=(val)
    val.upcase!
    write_attribute(:symbol, val)
  end

  def self.create_stock(symbol)
    stock = Stock.includes(:values).find_or_create_by(symbol: symbol)

    create_loop(stock.earliest_date) do |start_date, end_date|
      process(stock, StockQuote::Stock.quote(symbol, start_date, end_date))
    end
  end

  def earliest_date
    values.last.try(:date) || Value.first.date
  end

  private

  def self.create_loop(start_date)
    end_date = start_date + 1.year
    begin
      yield(start_date.to_s, end_date.to_s)
      start_date = end_date + 1.day
      end_date += 1.year
      end_date = Date.today if end_date > Date.today
    end while end_date <= Date.today && start_date < end_date
  end

  def self.process(stock, quotes)
    quotes.each do |quote|
      Value.find_or_create_by(stock: stock, date: quote.date, price: quote.close)
    end
  end
end
