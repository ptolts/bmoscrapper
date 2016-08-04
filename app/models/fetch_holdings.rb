class FetchHoldings
  def self.fetch(note)
    command = "curl 'https://www.bmocm.com/investorsolutions/principal-at-risk-notes/details/?id=#{note.note_id}' -H 'Accept-Encoding: gzip, deflate, sdch, br' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Cookie: referrer=undefined' -H 'Connection: keep-alive' --compressed"
    page = `#{command}`
    id = file_id(page)
    pdf_text = fetch_pdf_to_text(id)
  end

  def self.fetch_pdf_to_text(id)
    temp_file = '/tmp/pdf.pdf'
    command = "curl 'https://www.bmocm.com/common/investorsolutions/scripts/getFile.aspx?fileID=#{id}' -H 'Accept-Encoding: gzip, deflate, sdch, br' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: https://www.bmocm.com/investorsolutions/principal-at-risk-notes/details/?id=2240' -H 'Cookie: referrer=undefined' -H 'Connection: keep-alive' --compressed -o #{temp_file}"
    system(command)
    pdf = `pdftotext -table #{temp_file} -`.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
    symbols = holdings(pdf)
    byebug
  end

  def self.holdings(pdf_text)
    pdf_text.scan(/(?<ticker>[A-Z]{2,}).*?(?<weight>\d+\.\d+)/)
  end

  def self.file_id(page)
    page.scan(/(?:(?:Investor Brochure).*?href=\".*?)(?<file_id>\d+)/).first.first.chomp
  end
end
