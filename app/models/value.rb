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
#  stock_id   :integer
#

class Value < ActiveRecord::Base
  belongs_to :note
  belongs_to :stock

  default_scope -> { order(:date) }
end
