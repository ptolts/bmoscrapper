require 'byebug'
require 'digest/sha1'
require 'fileutils'
require 'nokogiri'
require 'parallel'

directory = './pages'

unless File.directory?(directory)
  FileUtils.mkdir_p(directory)
end

Parallel.each((0..4000).to_a, in_processes: 2) do |id|
  command = "curl 'https://www.bmocm.com/investorsolutions/principal-at-risk-notes/details/?id=#{id}' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.94 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Cookie: referrer=undefined; ASP.NET_SessionId=1hcioq3wpkp035qojcpbamez' -H 'Connection: keep-alive' --compressed"
  sha = Digest::SHA1.hexdigest(command)
  file_path = (directory + '/' + sha.to_s)

  if File.file?(file_path) && File.size(file_path) > 0
    page = File.read(file_path)
  else
    puts "Fetching #{id}"
    page = `#{command}` # &>/dev/null`
    File.open(file_path, 'w') {|f| f.write(page) }
  end

  File.open("#{file_path}_#{id}", 'w') {|f| f.write(page) }

  html_doc = Nokogiri::HTML(page)
  title = html_doc.xpath("//*[@class=\"title2\"]").first
  next unless title
  bid_price = html_doc.xpath("//*[contains(text(),'Current Bid Price')]/../td[2]").first.content rescue nil
  note_name = html_doc.xpath("//*[@class=\"title3\"]").first.content rescue nil
  next unless note_name
  puts "#{title.content} -> #{bid_price} [#{note_name}]"
end
