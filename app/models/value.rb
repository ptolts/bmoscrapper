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

class Value < ActiveRecord::Base
  belongs_to :note
end
