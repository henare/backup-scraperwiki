require 'rss/2.0'
require 'date'

feed = RSS::Parser.parse("http://eplanning.parracity.nsw.gov.au/Pages/XC.Track/SearchApplication.aspx?o=rss&d=last14days", false)

feed.channel.items.each do |item|
  record = {
    'council_reference' => item.title.split(' ')[0],
    'description'       => item.description.split('.')[1].strip,
    # Have to make this a string to get the date library to parse it
    'date_received'     => Date.parse(item.pubDate.to_s),
    'address'           => item.description.split('.')[0].strip,
    'info_url'          => item.link,
    # Comment URL is actually an email address but I think it's best
    # they go to the detail page
    'comment_url'       => item.link,
    'date_scraped'      => Date.today.to_s
  }
  
  if ScraperWiki.select("* from swdata where `council_reference`='#{record['council_reference']}'").empty? 
    ScraperWiki.save_sqlite(['council_reference'], record)
  else
     puts "Skipping already saved record " + record['council_reference']
  end
end

