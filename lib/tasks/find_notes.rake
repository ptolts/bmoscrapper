require 'csv'

def setup_directory
  directory = './pages'
  unless File.directory?(directory)
    FileUtils.mkdir_p(directory)
  end
  directory
end

def fetch_page(command, directory, id)
  sha = Digest::SHA1.hexdigest(command)
  file_path = (directory + '/' + sha.to_s)
  if false && File.file?(file_path) && File.size(file_path) > 0
    page = File.read(file_path)
  else
    puts "Fetching #{id}"
    page = `#{command}` # &>/dev/null`
    File.open(file_path, 'w') {|f| f.write(page) }
  end
  File.open("#{file_path}_#{id}", 'w') {|f| f.write(page) }
  page
end

task :find_notes => :environment do
  directory = setup_directory
  (0..4000).each do |id|
    command = "curl 'https://www.bmocm.com/investorsolutions/principal-at-risk-notes/details/?id=#{id}' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.94 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Cookie: referrer=undefined; ASP.NET_SessionId=1hcioq3wpkp035qojcpbamez' -H 'Connection: keep-alive' --compressed"
    page = fetch_page(command, directory, id)

    html_doc = Nokogiri::HTML(page)
    title = html_doc.xpath("//*[@class=\"title2\"]").first.content rescue nil
    next unless title
    bid_price = html_doc.xpath("//*[contains(text(),'Current Bid Price')]/../td[2]").first.content rescue nil
    issue_date = html_doc.xpath("//*[contains(text(),'Issue Date:')]/../td[2]").first.content rescue nil
    note_name = html_doc.xpath("//*[@class=\"title3\"]").first.content rescue nil
    next unless note_name
    puts "#{title} -> #{bid_price} [#{note_name}] [#{issue_date}]"

    name = note_name.scan(/[A-Z]{3}[0-9]+/).first
    note = Note.find_or_initialize_by(name: name)
    note.date = issue_date
    note.full_name = title
    note.note_id = id
    note.save
  end
end

# &a=#{start_date.month}&b=#{start_date.day}&c=#{start_date.year}&d=#{end_date.month}&e=#{end_date.day}&f=#{end_date.year}

task :find_returns => :environment do
  directory = setup_directory
  Note.q_model.each do |note|
    puts note.name
    command = "curl 'https://www.bmocm.com/investorsolutions/historical/?fundnum=#{note.name}&pro=PARN' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.94 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: https://www.bmocm.com/investorsolutions/principal-at-risk-notes/details/?id=2240' -H 'Cookie: referrer=undefined; ASP.NET_SessionId=1hcioq3wpkp035qojcpbamez' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' --compressed"
    page = fetch_page(command, directory, note.name)
    doc = Nokogiri::HTML(page)
    doc.xpath('//table//td').to_a.each_slice(3) do |row|
      date = Date.parse(row[0].text).to_s
      value = row[1].text.gsub(/[^0-9\.]/,'').to_f
      price = Value.find_or_initialize_by(note: note, date: date)
      price.price = value
      price.save
    end
  end
  Stock.all.each do |stock|
    Stock.create_stock(stock.symbol)
  end
end
