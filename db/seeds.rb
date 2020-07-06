require 'open-uri'

def scrape_page(url)
  Nokogiri::HTML(URI.open(url))
end

# url, e.g.: https://www.pcgs.com/coinfacts/coin/1850-20/8902/rarity/series
# creates coins from PCGS site. designer e.g. "Augustus St. Gauden", category e.g. "Double Eagles", denomination e.g. '$5', '50C'
def create_coin_series(url, category, designer, generic_img_url, diameter = nil, mass = nil)
  year_and_mintmark_pattern = /^\d{4}(-(CC|C|D|O|S))*/

  page = scrape_page(url)

  denomination = page.css('#TableRarity td')[1]
                     .text
                     .match(/\$\d{1,2}(\.\d+)*|\d{1,2}C/)
                     .to_s
  series = ''

  Coin.transaction do
    page.css('tbody tr').each do | tr | 
      series = page.css('ul.breadcrumb-list li a.text-muted').children[3].text
      pcgs_num, year_mintmark_and_designation, mintage = tr.text.gsub("\r\n", '').strip.split(/\s{2,}/).first(3)

      year_mintmark_and_designation = year_mintmark_and_designation.sub(" #{denomination}", '').sub('G$1', '')
      #year_and_mintmark_pattern will fail on overdates like 1879/8-CC etc. fix later - possibly .sub('/', " Over ").strip
      year, mintmark      = year_mintmark_and_designation.match(year_and_mintmark_pattern).to_s.split('-')
      special_designation = year_mintmark_and_designation.sub(year_and_mintmark_pattern, '').sub("/", " Over ").strip

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

  unless Series.find_by(name: series)
    series_coin = Coin.last

    Series.create(
      name: series,
      generic_img_url: series_coin.generic_img_url,
      mass: series_coin.mass,
      diameter: series_coin.diameter,
      denomination: series_coin.denomination
    )
  end
  nil
end

#URL, e.g. https://www.pcgs.com/pop/detail/classic-head-2-5-1834-1839/757/0?t=5&pn=1; choose "Comprehensive", view "all"
def add_pcgs_pop_to_coins(url)
  page = scrape_page(url)

  page.css('tbody tr')[3..-1].each do | tr |
    row = tr.text.gsub("\r\n",'').gsub(/\s+|Shop|MS|\+/, ' ').strip.split(/\s\s+/)

    next if row[0] == "Total"

    pcgs_num, description = row
    
    next unless description && !description.match?(/(PL|PR|SP)$/)

    total_pcgs_population = row[-1].split[-1]&.delete(',').to_i
    denomination          = description.match(/\$\d{1,2}(\.\d+)*|\d{1,2}C/).to_s
    mintmark              = description.match(/-(CC|C|D|O|S)(?=\s)/).to_s.sub('-', '')
    year                  = description.match(/^\d{4}/).to_s

    special_designation = description.sub(denomination, '')
                                     .sub("-#{mintmark}", '')
                                     .sub(year, '')
                                     .sub(' G', '')
                                     .gsub(/\s+/, ' ')
                                     .sub('/', ' Over ')
                                     .sub(/(\d+ to|about|under|less than|Est\.) \d+ known/, '')
                                     .sub(/\d+ known/, '')
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

    tr.children.css('td')[3..-2].each_with_index do | td, idx | 
      pop_at_grade = td.css('div').first&.text&.delete(',')&.to_i || 0

      grade = grade_array[idx]

      population_by_condition[grade] = pop_at_grade
    end

    population_by_condition[:total] = total_pcgs_population || 0

    coin = Coin.find_by(year: year, denomination: denomination, mintmark: mintmark, special_designation: special_designation)

    unless coin
      puts "failed to get population data for #{denomination} #{year} #{mintmark}"
      next
    end

    coin.update(pcgs_population: population_by_condition)
  end
  nil
end