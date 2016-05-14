require 'byebug'
require 'digest/sha1'
require 'fileutils'
require 'nokogiri'

directory = './pages'

dirname = File.dirname(directory)
unless File.directory?(dirname)
  FileUtils.mkdir_p(dirname)
end

(0..4000).each do |id|
  command = "curl 'https://www.bmocm.com/investorsolutions/principal-at-risk-notes/details/?id=#{id}' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.94 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Cookie: referrer=undefined; ASP.NET_SessionId=1hcioq3wpkp035qojcpbamez' -H 'Connection: keep-alive' --compressed"
  sha = Digest::SHA1.hexdigest(command)

  if file_path = directory + '/' + sha.to_s && File.file?(file_path)
    page = File.read(file_path)
  else
    page = system(command)
    File.open(file_path, 'w') {|f| f.write(page) }
  end

  html_doc = Nokogiri::HTML(page)
  title = html_doc.xpath("//*[@class=\"title2\"]").content
  byebug
  break
end
