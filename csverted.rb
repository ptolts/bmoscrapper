require 'enumerator'
require 'date'
require 'rubygems'
require 'nokogiri'
require 'csv'
require 'byebug'
require 'money/bank/historical_bank'
mh = Money::Bank::HistoricalBank.new

command = "curl '#{ARGV[0]}' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.94 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Cookie: referrer=undefined; ASP.NET_SessionId=1hcioq3wpkp035qojcpbamez' -H 'Connection: keep-alive' --compressed"

file = `#{command}`

doc = Nokogiri::HTML(file)

csv = CSV.open("output.csv", 'w',{:col_sep => ",", :quote_char => '\''})

doc.xpath('//table//td').to_a.each_slice(3) do |row|
  csv << [Date.parse(row[0].text).to_s, row[1].text.gsub(/[^0-9\.]/,'').to_f]
end

csv.close
