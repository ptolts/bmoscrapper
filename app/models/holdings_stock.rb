class HoldingsStock < ActiveRecord::Base
  belongs_to :stock
  belongs_to :holding
end
