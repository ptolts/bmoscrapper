class DifferenceService
  def initialize
    @difference = []
  end

  def process(data)
    @data = data
    @data.each do |note|
      note_data = { name: note[:name], data: [] }
      previous = nil
      note[:data].each do |day|
        previous = day and next unless previous
        diff = ((day[1] - previous[1]) / previous[1])
        note_data[:data] << [day[0], diff]
        previous = day
      end
      @difference << note_data
    end
    @difference
  end
end
