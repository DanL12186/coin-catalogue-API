require 'open-uri'

#get page with nokogiri + openuri eg page = Nokogiri::HTML(URI.open("https://www.pcgs.com/coinfacts/coin/1850-20/8902/rarity/series"))
#can scrape PCGS population from here ($5 gold example).. but need to work out kinks https://www.pcgs.com/pop/detail/category/61?l=liberty-head-5-1839-1908&ccid=0&t=5&p=MS&pn=1&ps=-1

def scrape_page(url)
  Nokogiri::HTML(URI.open(url))
end

#get the series later; e.g. Liberty Head $10, not just $10 Eagles
#https://www.pcgs.com/coinfacts/coin/1850-20/8902/rarity/series
#creates coins from PCGS site. page = scraped page, designer e.g. "Augustus St. Gauden", category e.g. "Double Eagles", denomination e.g. '$5', '50C'
def create_coin_series(url, category, designer, generic_img_url, diameter = nil, mass = nil)
  year_and_mintmark_pattern = /^\d{4}(-(CC|C|D|O|S))*/

  page = scrape_page(url)
  denomination = page.css('#TableRarity td')[1]
                     .text
                     .match(/\$(1|2\.50|5|3|4|10|20)|\s(50|25|10|5|1)C/)
                     .to_s
                     .strip
                     
  Coin.transaction do
    page.css('tbody tr').each do | tr | 
      series = page.css('ul.breadcrumb-list li a.text-muted').children[3].text
      pcgs_num, year_and_mintmark, mintage = tr.text.gsub("\r\n", '').strip.split(/\s\s+/).first(3)

      year_and_mintmark.gsub!(" #{denomination}", '').sub!('G$1', '')
      #P occurs in a very few nickels, W for 21st century proof silver
      year, mintmark      = year_and_mintmark.match(year_and_mintmark_pattern).to_s.split('-')
      special_designation = year_and_mintmark.sub(year_and_mintmark_pattern, '').strip

      Coin.create(
                  pcgs_num: pcgs_num.to_i, 
                  year: year.to_i, 
                  mintmark: mintmark,
                  mintage: mintage.to_i,
                  category: category,
                  designer: designer,
                  denomination: denomination,
                  series: series, 
                  generic_img_url: generic_img_url, 
                  special_designation: special_designation,
                  diameter: diameter,
                  mass: mass
      )
    end
  end
  nil
end

#URL, e.g. https://www.pcgs.com/pop/detail/classic-head-2-5-1834-1839/757/0?t=5&pn=1; choose "Comprehensive", view "all"
#needs to be refactored now that special designation exists
def add_pcgs_pop_to_coins(url)
  page = scrape_page(url)

  page.css('tbody tr')[3..-1].each do | tr |
    row = tr.text.gsub("\r\n",'').gsub(/\s+|Shop|MS|\+/, ' ').strip.split(/\s\s+/);
    
    next if row[0] == "Total"

    pcgs_num, description = row
    
    next unless description && !description.match?(/(PL|PR)$/)

    total_pcgs_population = row[-1].split[-1]&.delete(',').to_i
    denomination          = description.match(/\$\d{1,2}(\.\d+)*|\d{1,2}C/).to_s
    year                  = description.match(/^\d{4}/).to_s

    #future mintmark, when special_designation is in place
    #mintmark = description.match(/\d{4}-[A-Z]/).to_s

    mintmark = description.sub(denomination, '')
                          .sub(year, '')
                          .sub(' G', '')
                          .sub(/^-/,'')
                          .gsub(/\s+/, ' ')
                          .sub(/(\d+ to|about|under|less than) \d+ known/, '')
                          .strip

    mintmark = nil if mintmark.empty?

    population_by_condition = { 
      VG: 0,
      F:	0,
      VF: 0,
      XF40:	0,
      XF45: 0,
      AU50: 0,
      AU53:	0,
      AU55: 0,
      AU58:	0,
      MS60: 0,
      MS61:	0, 
      MS62: 0, 
      MS63:	0, 
      MS64: 0, 
      MS65:	0,
      MS66: 0, 
      MS67: 0,
      MS68: 0, 
      MS69: 0,
      MS70: 0,
    }

    grade_array = population_by_condition.keys

    next unless tr.children.css('td')[3]

    tr.children.css('td')[3..-1].each_with_index do | td, idx | 
      pop_at_grade = td.css('div').first&.text&.delete(',')&.to_i

      grade = grade_array[idx]

      population_by_condition[grade] = pop_at_grade
    end

    population_by_condition[:total] = total_pcgs_population

    coin = Coin.find_by(year: year, denomination: denomination, mintmark: mintmark)

    unless coin
      puts "failed to get population data for #{denomination} #{year} #{mintmark}"
      next
    end

    coin.update(pcgs_population: population_by_condition)
  end
  nil
end