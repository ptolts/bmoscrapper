# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  name       :text
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  note_id    :integer
#  full_name  :text
#

class Note < ActiveRecord::Base
  has_many :values
  has_many :holdings

  validates :name, uniqueness: true

  scope :q_model, -> {
                        includes(:values)
                        .where("full_name ~* ?", '.*U\.?S\.?\sQ\-Model.*')
                      }

  def group_values_by_date
    values.each_with_object({}) do |value, hash|
      hash[value.date] = value.price
    end
  end

  def self.all_returns
    total_hash = Hash.new { |h, k| h[k] = [] }

    Note.includes(:values).all.each do |note|
      next unless note.full_name =~ /US Q-Model/
      note.returns.each_pair do |key, value|
        total_hash[key.to_s] << value
      end
    end

    total_hash
  end

  # def self.q_model
  #   Note.includes(:values).all.each do |note|
  #     next unless note.full_name =~ /US Q-Model/
  #     note.quarterly_returns.to_s
  #   end

  #   nil
  # end

  def returns
    totals = {}
    values_by_year.each do |year, values|
      last_day = values.max
      first_day = values.min
      totals[year] = rate_of_change(first_day: first_day, last_day: last_day)
      # puts "#{year} -> #{change} [#{first_day.date} -> #{first_day.price}][#{last_day.date} -> #{last_day.price}]"
    end
    totals
  end

  def quarterly_returns
    start_dt = values.max
    end_dt = values.min
    start_dates = (start_dt.date..end_dt.date).group_by(&:beginning_of_quarter).keys
    end_dates = (start_dt.date..end_dt.date).group_by(&:end_of_quarter).keys
    start_dates.zip(end_dates).each do |quarter|
      range = (quarter.first..quarter.last)
      dates = values.find_all{ |value| range.include?(value.date.to_date) }
      start_dt = dates.min
      end_dt = dates.max
      change = rate_of_change(first_day: start_dt, last_day: end_dt)
      next unless change.abs > 10
      puts "#{quarter.to_s} -> #{change}"
    end
  end

  private

  def values_by_year
    values.group_by do |value|
      value.date.year
    end
  end

  def rate_of_change(first_day:, last_day:)
    (first_day.price - last_day.price) / last_day.price * 100
  end
end
