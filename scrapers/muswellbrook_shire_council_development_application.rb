require 'mechanize'
require 'date'

agent = Mechanize.new
url = "http://www.muswellbrook.nsw.gov.au/Council-services/Planning-development/Current-development-applications.htm"

page = agent.get(url)

page.search('table.mcs').each do |t|
  on_notice_to = Date.parse(t.at('caption').inner_text)

  t.search('tr').each do |r|
    next if r.at('th') || r.at('td').nil? 

    record = {
      :on_notice_to => on_notice_to,
      :council_reference => r.search('td')[0].inner_text.strip,
      :address => r.search('td')[1].inner_html.split('<br>')[0].strip,
      :description => r.search('td')[2].inner_text,
      :date_scraped => Date.today,
      :info_url => url,
      :comment_url => 'mailto:council@muswellbrook.nsw.gov.au'
    }

    if ScraperWiki.select("* from swdata where `council_reference`='#{record[:council_reference]}'").empty? 
      ScraperWiki.save_sqlite([:council_reference], record)
    else
      puts "Skipping already saved record " + record[:council_reference]
    end
  end
end
