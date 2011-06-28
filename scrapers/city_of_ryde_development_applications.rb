require 'rubygems'
require 'mechanize'

url = 'http://www.ryde.nsw.gov.au/development/pn.htm'
agent = Mechanize.new

page = agent.get(url)

page.search('.Bold').each do |b|
  details = b.parent.inner_html.split('<br>')
  
  # Skip if this isn't a DA
  next if details.count != 4
  
  # Sometimes we get crazy characters in the council_reference
  council_reference = details[1].split(' ')[-1].strip
  if !council_reference.split("\240")[1].nil? 
    council_reference = council_reference.split("\240")[1]
  end
  
  record = {
    'council_reference' => council_reference,
    'description'       => details[3].strip,
    'address'           => details[0].gsub(/\302\240/, ' ').split('<span class="Bold">Property</span>: ')[1].strip,
    'info_url'          => url,
    'comment_url'       => url,
    'date_scraped'      => Date.today.to_s
  }
  
  if ScraperWiki.select("* from swdata where `council_reference`='#{record['council_reference']}'").empty? 
    ScraperWiki.save_sqlite(['council_reference'], record)
  else
     puts "Skipping already saved record " + record['council_reference']
  end
end
