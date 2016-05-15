class Note < ActiveRecord::Base
  has_many :values

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

  def returns
    totals = {}
    values_by_year.each do |year, values|
      last_day = values.max
      first_day = values.min
      change = (first_day.price - last_day.price)/last_day.price * 100
      totals[year] = change
      # puts "#{year} -> #{change} [#{first_day.date} -> #{first_day.price}][#{last_day.date} -> #{last_day.price}]"
    end
    totals
  end

  private

  def values_by_year
    values.group_by do |value|
      value.date.year
    end
  end
end
