require 'rubygems'
require 'mechanize'

agent = Mechanize.new
base_url = 'http://majorprojects.planning.nsw.gov.au/index.pl'
url = base_url + '?action=search&status_id=6'

page = agent.get(url)

page.search('tr.green_row').each do |r|
  application = agent.get(base_url + URI.parse(r.at('a').attributes['href']).to_s)
  project_table = application.at('table.project_table')
  
  # Exceptions
  # Skip applications if notice dates look out of place, unfortunately
  # we're going to miss some applications here
  next unless project_table.search('tr.project_subheading')[2].next.at('tr[4]')
  next unless project_table.search('tr.project_subheading')[2].next.at('tr[4]').children[2]
  # Skip SSS applications
  next if project_table.search('tr.project_subheading')[1].next.at('tr[1]').inner_text.strip == 'Assessment Type: SSS'
  next if project_table.search('tr.project_subheading')[2].next.at('tr[1]').inner_text.strip == 'Assessment Type: SSS'

  record = {
    'description'       => project_table.search('tr.project_subheading')[0].next.inner_text.strip,
    'address'           => project_table.search('tr.project_subheading_split')[1].next.inner_text.strip,
    'council_reference' => project_table.search('tr.project_subheading')[2].next.at('tr[2]').inner_text.strip[20..-1],
    'on_notice_from'    => project_table.search('tr.project_subheading')[2].next.at('tr[4]').children[0].inner_text[-10..-1],
    'on_notice_to'      => project_table.search('tr.project_subheading')[2].next.at('tr[4]').children[2].inner_text[-10..-1],
    'info_url'          => application.uri.to_s,
    'comment_url'       => application.uri.to_s,
    'date_scraped'      => Date.today.to_s
  }
  
  if ScraperWiki.select("* from swdata where `council_reference`='#{record['council_reference']}'").empty? 
    ScraperWiki.save_sqlite(['council_reference'], record)
  else
    puts "Skipping already saved record " + record['council_reference']
  end
end

