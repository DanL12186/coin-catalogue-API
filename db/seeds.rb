require 'open-uri'

#get page with nokogiri + openuri eg page = Nokogiri::HTML(URI.open("https://www.pcgs.com/coinfacts/coin/1850-20/8902/rarity/series"))

# Coin.transaction do
#   page.css('tbody tr').each do | tr | 
#     category = "Double Eagles"
#     designer = "James B. Longacre"
#     pcgs_num, year_and_mintmark, mintage = tr.text.gsub("\r\n",'').strip.split(/\s\s+/).first(3)
    
#     year_and_mintmark.gsub!(" $20", '')
#     year, mintmark = year_and_mintmark.split('-')

#     Coin.create(pcgs_num: pcgs_num.to_i, year: year.to_i, mintmark: mintmark, mintage: mintage.to_i, category: category, designer: designer)
#   end
# end

#can scrape PCGS population from here ($5 gold example).. but need to work out kinks https://www.pcgs.com/pop/detail/category/61?l=liberty-head-5-1839-1908&ccid=0&t=5&p=MS&pn=1&ps=-1

def scrape_page(url)
  Nokogiri::HTML(URI.open(url))
end

#get the series later; e.g. Liberty Head $10, not just $10 Eagles
#https://www.pcgs.com/coinfacts/coin/1850-20/8902/rarity/series
#creates coins from PCGS site. page = scraped page, designer e.g. "Augustus St. Gauden", category e.g. "Double Eagles", denomination e.g. '$5', '50C'
def create_coin_series(page, category, designer, denomination, series)
  denomination = "$2.50" if denomination == "$2.5"
  
  Coin.transaction do
    page.css('tbody tr').each do | tr | 
      pcgs_num, year_and_mintmark, mintage = tr.text.gsub("\r\n", '').strip.split(/\s\s+/).first(3)
      
      year_and_mintmark.gsub!(" #{denomination}", '')
      year, mintmark = year_and_mintmark.split('-')

      Coin.create!(pcgs_num: pcgs_num.to_i, year: year.to_i, mintmark: mintmark, mintage: mintage.to_i, category: category, designer: designer, denomination: denomination, series: series)
    end
  end
end

#how to account for ignoring + ratings?
page.css('tbody tr')[2..7].each do | tr |
  row = tr.text.gsub("\r\n",'').gsub(/\s+|Shop|MS|\+/, ' ').strip.split(/\s\s+/);
  next if row[0] == "Total"
  puts row.to_s
  pcgs_num, description, population_by_condition = row

  population_arr = population_by_condition
end

 page.css('tbody tr')[3..7].each do | tr |
  row = tr.text.gsub("\r\n",'').gsub(/\s+|Shop|MS|\+/, ' ').strip.split(/\s\s+/);
   next if row[0] == "Total"
   puts row.to_s
   pcgs_num, description, population_by_condition = row
   
   population_arr = population_by_condition.gsub(/\s+/, ' ').split.select.with_index { | entry, idx | idx.even? }.map(&:to_i)
   binding.pry
end;1