require 'byebug'
require 'digest/sha1'
require 'fileutils'
require 'nokogiri'
require 'parallel'

directory = './pages'

unless File.directory?(directory)
  FileUtils.mkdir_p(directory)
end

Parallel.each((0..4000).to_a, in_processes: 8) do |id|
  # puts "Fetching #{id}"

  command = "curl 'https://www.bmocm.com/investorsolutions/principal-at-risk-notes/details/?id=#{id}' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.94 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Cookie: referrer=undefined; ASP.NET_SessionId=1hcioq3wpkp035qojcpbamez' -H 'Connection: keep-alive' --compressed"
  sha = Digest::SHA1.hexdigest(command)
  file_path = (directory + '/' + sha.to_s)

  if File.file?(file_path)
    page = File.read(file_path)
  else
    page = `#{command} &>/dev/null`
    sleep 1
    File.open(file_path, 'w') {|f| f.write(page) }
  end

  html_doc = Nokogiri::HTML(page)
  title = html_doc.xpath("//*[@class=\"title2\"]").first
  next unless title
  bid_price = html_doc.xpath("//*[contains(text(),'Current Bid Price')]/../td[2]").first.content

  puts "#{title.content} -> #{bid_price}"
end
