# frozen_string_literal: true
namespace :binance do

  task snatch_article: :environment do
    print "search binance topic"
    res = Nokogiri::HTML  RestClient.get('https://www.binance.com/zh-CN/support/announcement/c-48?navId=48').body
    first_text = res.css('a.css-1ej4hfo')[0].text.to_s
    if first_text.include?('币安上市') && !first_text.include?('RARE')
      url = "https://sctapi.ftqq.com/SCT83964TIkzGyqCjO8WN2EsrXbgBLUh8.send?title=#{first_text}"
      RestClient.get(URI.encode url)
    end
  end
end

