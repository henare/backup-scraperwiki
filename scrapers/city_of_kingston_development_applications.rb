require 'rubygems'
require 'mechanize'
require 'date'

agent = Mechanize.new
url = 'http://www.kingston.vic.gov.au/web/map/?m=planning_register'

page = agent.get(url)

# Get the bloody big table
table = page.at('/html/body/table[2]')

table.search('tr').each do |r|
  # If the last table cell doesn't contain the word "map", it's not a DA
  begin
    if r.search('td').last.inner_text != "Map"
      next
    end
  rescue
    #puts "Not a development application, keeping calm and carrying on"
    next
  end
  
  # Some DAs don't have an on notice to
  begin
    on_notice_to = Date.parse(r.search('td')[6].inner_text).to_s
  rescue
    on_notice_to = ''
  end
  
  record = {
    'description'       => r.search('td')[0].inner_text,
    'council_reference' => r.search('td')[1].inner_text,
    'address'           => r.search('td')[2].inner_text,
    'date_received'     => Date.parse(r.search('td')[3].inner_text).to_s,
    'on_notice_to'      => on_notice_to,
    'info_url'          => 'http://www.kingston.vic.gov.au/web/map/?m=planning_register',
    # Eugh - just the contact us page :(
    'comment_url'       => 'http://www.kingston.vic.gov.au/Page/Page.asp?Page_Id=34&h=-1',
    'date_scraped'      => Date.today.to_s
  }
  
  if ScraperWiki.select("* from swdata where `council_reference`='#{record['council_reference']}'").empty? 
    ScraperWiki.save_sqlite(['council_reference'], record)
  else
    puts "Skipping already saved record " + record['council_reference']
  end
end

