class Holding < ActiveRecord::Base
  belongs_to :note
  has_many :holdings_stocks
  has_many :stocks, through: :holdings_stocks
end
