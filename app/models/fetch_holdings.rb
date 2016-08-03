class FetchHoldings
  def self.fetch_holding_for_note(note)
    command = "curl 'https://www.bmocm.com/investorsolutions/principal-at-risk-notes/details/?id=#{note.note_id}' -H 'Accept-Encoding: gzip, deflate, sdch, br' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Cookie: referrer=undefined' -H 'Connection: keep-alive' --compressed"
    page = `#{command}`
    id = file_id(page)
    pdf_text = fetch_pdf_to_text(id)
  end

  def self.fetch_pdf_to_text(id)
    command = "curl 'https://www.bmocm.com/common/investorsolutions/scripts/getFile.aspx?fileID=#{id}' -H 'Accept-Encoding: gzip, deflate, sdch, br' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: https://www.bmocm.com/investorsolutions/principal-at-risk-notes/details/?id=2240' -H 'Cookie: referrer=undefined' -H 'Connection: keep-alive' --compressed"
    pdf = `#{command}`
    byebug
  end

  def self.holdings(pdf_text)
    /(?<ticker>[A-Z]{2,}).*?(?<weight>\d+\.\d+)/
  end

  def self.file_id(page)
    page.scan(/(?:(?:Monthly Portfolio Summary).*?href=\".*?)(?<file_id>\d+)/).first.first.chomp
  end
end
