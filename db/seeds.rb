require 'open-uri'

RARITY = {
  '10.1' => '0',
  '10'  => '1',
  '9.9' => '2',
  '9.8' => '3 - 4',
  '9.7' => '5 - 6',
  '9.6' => '7 - 9',
  '9.5' => '10 - 12',
  '9.4' => '13 - 14',
  '9.3' => '15 - 16',
  '9.2' => '17 - 18',
  '9.1' => '19 - 20',
  '9'   => '21 - 25',
  '8.9' => '26 - 30',
  '8.8' => '31 - 35',
  '8.7' => '36 - 40',
  '8.6' => '41 - 45',
  '8.5' => '46 - 50',
  '8.4' => '50 - 60',
  '8.3' => '60 - 70',
  '8.2' => '70 - 80',
  '8.1' => '80 - 90',
  '8'   => '90 - 100',
  '7.9' => '100 - 110',
  '7.8' => '110 - 120',
  '7.7' => '120 - 130',
  '7.6' => '130 - 140',
  '7.5' => '140 - 150',
  '7.4' => '150 - 160',
  '7.3' => '160 - 170',
  '7.2' => '170 - 180',
  '7.1' => '180 - 190',
  '7'   => '190 - 200',
  '6.9' => '200 - 210',
  '6.8' => '210 - 220',
  '6.7' => '220 - 240',
  '6.6' => '240 - 260',
  '6.5' => '260 - 280',
  '6.4' => '280 - 300',
  '6.3' => '300 - 350',
  '6.2' => '350 - 400',
  '6.1' => '400 - 450',
  '6'   => '450 - 500',
  '5.9' => '500 - 550',
  '5.8' => '550 - 600',
  '5.7' => '600 - 650',
  '5.6' => '650 - 700',
  '5.5' => '700 - 750',
  '5.4' => '750 - 800',
  '5.3' => '800 - 850',
  '5.2' => '850 - 900',
  '5.1' => '900 - 950',
  '5'   => '950 - 1000',
  '4.9' => '1000 - 1250',
  '4.8' => '1250 - 1500',
  '4.7' => '1500 - 1750',
  '4.6' => '1750 - 2000',
  '4.5' => '2000 - 2500',
  '4.4' => '2500 - 3000',
  '4.3' => '3000 - 3500',
  '4.2' => '3500 - 4000',
  '4.1' => '4000 - 4500',
  '4'   => '4500 - 5000',
  '3.9' => '5000 - 5500',
  '3.8' => '5500 - 6000',
  '3.7' => '6000 - 6500',
  '3.6' => '6500 - 7000',
  '3.5' => '7000 - 7500',
  '3.4' => '7500 - 8000',
  '3.3' => '8000 - 8500',
  '3.2' => '8500 - 9000',
  '3.1' => '9000 - 9500',
  '3'   => '9500 - 10000',
  '2.9' => '10000 - 15000',
  '2.8' => '15000 - 20000',
  '2.7' => '20000 - 30000',
  '2.6' => '30000 - 40000',
  '2.5' => '40000 - 50000',
  '2.4' => '50000 - 60000',
  '2.3' => '60000 - 70000',
  '2.2' => '70000 - 80000',
  '2.1' => '80000 - 90000',
  '2'   => '90000 - 100000',
  '1.9' => '100000 - 200000',
  '1.8' => '200000 - 300000',
  '1.7' => '300000 - 400000',
  '1.6' => '400000 - 500000',
  '1.5' => '500000 - 600000',
  '1.4' => '600000 - 700000',
  '1.3' => '700000 - 800000',
  '1.2' => '800000 - 900000',
  '1.1' => '900000 - 1000000',
  '1'   => '1000000'
}

def scrape_page(url)
  Nokogiri::HTML(URI.open(url))
end

# url, e.g.: https://www.pcgs.com/coinfacts/coin/1850-20/8902/rarity/series
# creates coins from PCGS site. designer e.g. "Augustus St. Gauden", category e.g. "Double Eagles", denomination e.g. '$5', '50C'
def create_coin_series(url, category, designer, generic_img_url, reverse_img_url, diameter = nil, mass = nil)
  year_and_mintmark_pattern = /^\d{4}(-(CC|C|D|O|S))*/
  first_year_of_issue = nil

  page = scrape_page(url)

  denomination = page.css('#TableRarity td')[1]
                     .text
                     .match(/\$\d{1,2}(\.\d+)*|\d{1,2}C/)
                     .to_s
  series = ''

  Coin.transaction do
    page.css('tbody tr').each do | tr | 
      series = page.css('ul.breadcrumb-list li a.text-muted').children[3].text

      pcgs_num, coin_desc, mintage, rarity_all, rarity_ms60, rarity_ms65 = tr.text.strip.split(/\s{2,}/).first(6)

      coin_desc           = coin_desc.sub(" #{denomination}", '').sub(/[TG]\$1/, '')
      year, mintmark      = coin_desc.match(year_and_mintmark_pattern).to_s.split('-')
      special_designation = coin_desc.sub(year_and_mintmark_pattern, '').sub("/", " Over ").strip

      first_year_of_issue ||= year

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
                  mass: mass,
                  estimated_survival_rates: { total: RARITY[rarity_all], MS60: RARITY[rarity_ms60], MS65: RARITY[rarity_ms65] }
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
      denomination: series_coin.denomination,
      date_range: "#{first_year_of_issue}-#{series_coin.year}",
      reverse_img_url: reverse_img_url
    )
  end
  nil
end

#URL, e.g. https://www.pcgs.com/pop/detail/classic-head-2-5-1834-1839/757/0?t=5&pn=1; choose "Comprehensive", view "all"
def add_pcgs_pop_to_coins(url)
  page = scrape_page(url)

  Coin.transaction do 
    page.css('tbody tr')[3..-1].each do | tr |
      row = tr.text.gsub("\r\n",'').gsub(/\s+|Shop|MS|\+/, ' ').strip.split(/\s\s+/)

      next if row[0] == "Total"

      pcgs_num, description = row
      
      next unless description && !description.match?(/(PL|PR|SP)$/)

      total_pcgs_population = row[-1].split[-1]&.delete(',').to_i

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

      coin = Coin.find_by(pcgs_num: pcgs_num)

      if coin
        coin.update(pcgs_population: population_by_condition)
      else
        puts "Couldn't find coin with PCGS ##{pcgs_num}"
      end
    end
    nil
  end
end

#Penultimate URI resource must be /all; #https://www.pcgs.com/prices/detail/morgan-dollar/744/all/ms
#default type is MS, as opposed to PL/DMPL/SP
def get_price_data_for_coins(url, type = 'MS')
  page = scrape_page(url)

  page.css('tbody tr')[3..-1].each do | tr |
    row = tr.text.gsub("\r\n",'').gsub(/\s+|Shop|MS|\+/, ' ').strip.split(/\s\s+/)

    next if row[0] == "Total"

    pcgs_num, description = row
    
    next unless description && !description.match?(/(PL|PR|SP)$/)

    price_by_condition = { 
      G04: 0,
      G06: 0,
      VG08: 0,
      VG10: 0,
      F12:	0,
      F15: 0,
      VF20: 0,
      VF25: 0,
      VF30: 0,
      VF35: 0,
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

    grade_array = price_by_condition.keys

    next unless tr.children.css('td')[3]

      tr.children.css('td')[6..-2].each_with_index do | td, idx | 
        pop_at_grade = td.css('a').first&.text&.delete(',▲▼')&.to_i || 0

        grade = grade_array[idx]

        price_by_condition[grade] = pop_at_grade
      end

    coin = Coin.find_by(pcgs_num: pcgs_num)

    if coin
      coin.update(price_table: price_by_condition)
    else
      puts "Couldn't find coin with PCGS ##{pcgs_num}"
    end
  end
  nil
end

def desc(coin)
  return nil if coin.nil?
  if coin.mintmark
    return "#{coin.year}-#{coin.mintmark} #{coin.special_designation}".strip
  else
    return "#{coin.year} #{coin.special_designation}".strip
  end
end

#add previous and next coin properties to all coins
def add_next_and_prev_to_coins
  Coin.transaction do
    Coin.distinct(:series).pluck(:series).each do | series |

      ordered_coins = Coin.select(:year, :mintmark, :special_designation, :id)
                          .where(series: series)
                          .sort_by { | coin | [coin.year, coin.mintmark || "", coin.special_designation ] }
          
      ordered_coins.each_with_index do | coin, idx |
        coin.next_coin = desc(ordered_coins[idx+1]) || desc(ordered_coins.first)
        coin.prev_coin = desc(ordered_coins[idx-1])
        coin.save
      end
    end
  end
end



def update_survival(url)
  page = scrape_page(url)

  denomination = page.css('#TableRarity td')[1]
                     .text
                     .match(/\$\d{1,2}(\.\d+)*|\d{1,2}C/)
                     .to_s

  Coin.transaction do
    page.css('tbody tr').each do | tr | 
      pcgs_num, coin_desc, mintage, rarity_all, rarity_ms60, rarity_ms65 = tr.text.strip.split(/\s{2,}/).first(6)
 
      coin = Coin.find_by(pcgs_num: pcgs_num)

      coin.update(estimated_survival_rates: { total: RARITY[rarity_all], MS60: RARITY[rarity_ms60], MS65: RARITY[rarity_ms65] })
    end
  end
  nil
end