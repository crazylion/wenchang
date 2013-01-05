require 'nokogiri'
require 'open-uri'
require 'faraday'
require 'mail'

namespace :acm do
  desc "TODO"
  task :download => :environment do

    p "download... "+ENV['page']
    doc = Nokogiri::HTML(open(ENV['page']))
    link = doc.css('a[name=FullTextPDF]')
    link = link[0]
    href= link['href'].to_s
#      p link['href']href= link['href'].to_s
    start_index =href.index("id=")+3
    end_index = href.index("&",start_index)
    id = href[start_index...end_index]
    unless File.exists?("#{id}.pdf")
      #  p href
      #  p "wget -O '#{id}.pdf' http://dl.acm.org/#{href} "
      `wget  --user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6" --header="Accept:text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" --header="Accept-Language: en-us,en;q=0.5" --header="Accept-Encoding: gzip,deflate" --header="Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7" -O  '#{id}.pdf' http://dl.acm.org/#{href} `
    end
  end

end
