require 'open-uri'
require 'nokogiri'

# Returns an array of Australian Postcodes: https://gist.github.com/1504308
def australian_postcodes
  # Postcodes that look like integers
  nsw = (1000..1999).to_a +
        (2000..2599).to_a +
        (2619..2898).to_a +
        (2921..2999).to_a
  act = (2600..2618).to_a +
        (2900..2920).to_a
  vic = (3000..3999).to_a +
        (8000..8999).to_a
  qld = (4000..4999).to_a +
        (9000..9999).to_a
  tas = (7000..7799).to_a +
        (7800..7999).to_a
  sa = (5000..5799).to_a +
       (5800..5999).to_a
  wa = (6000..6797).to_a +
       (6800..6999).to_a

  # Convert integers to strings (postcodes are *not* integers)
  postcodes = (nsw + act + vic + qld + tas + sa + wa).map { |p| p.to_s }

  # Postcodes from NT (and one range in the ACT don't look like integers)
  nt_and_act_range = (800..899).to_a + (900..999).to_a + (200..299).to_a

  postcodes + (nt_and_act_range.map { |p| "0#{p.to_s}" })
end

parsed_postcodes = ScraperWiki.select('* from parsed_postcodes').map { |r| r['postcode'] }

postcodes = australian_postcodes - parsed_postcodes

postcodes.each do |postcode|
  puts "Getting postcode: #{postcode}"
  
  api_result = Nokogiri.parse(open("http://abr.business.gov.au/abrxmlsearch/AbrXmlSearch.asmx/SearchByABNStatus?postcode=#{postcode}&activeABNsOnly=N&currentGSTRegistrationOnly=N&entityTypeCode=&authenticationGuid=082f1497-93ff-4fc3-9c85-030022b11840"))

  records = api_result.search('abn').map do |r|
    {abn: r.text, postcode: postcode}
  end

  ScraperWiki.save_sqlite ['abn'], records
  ScraperWiki.save_sqlite ["postcode"], {"postcode" => postcode}, "parsed_postcodes"
end
