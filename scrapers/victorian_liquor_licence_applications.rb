import scraperwiki
import requests
from bs4 import BeautifulSoup

url = 'https://liquor.justice.vic.gov.au/alarm_internet/alarm_internet.ASP?WCI=search_licence_applications&WCU'

form_data = {
  'Submit': 'Submit Request',
  'licence_category': '312',
  'sort_by': 'BY.DSND LODGE.DATE BY PREMISES.RESID.SUBURB|RECEIVED DATE, SUBURB'
}

page_html = requests.post(url, data=form_data, verify=False).content
page = BeautifulSoup(page_html)

results = page.find_all(attrs='result')

result = results[0]
result_details = result.find_all(attrs='result-details')

council_reference = result.find(attrs='result-title').text.split()[0]
date_received = result_details[0].p.text
address = result_details[1].p.text
description = result_details[2].p.text
