require 'scraperwiki'
require 'mechanize'
require 'date'

time = Time.new

base_url    = "http://eplanning.cumberland.nsw.gov.au/Pages/XC.Track/"
page_url = base_url + "SearchApplication.aspx?k=LodgementDate&t=&d=last14days"

agent   = Mechanize.new
page    = agent.get(page_url)
results = page.css("div[id='hiddenresult'] [class='result']")

# Extract application'ss
results.each do |result|
  record = {}
  record['council_reference'] = result.css('a').text.split("\r\n")[0]
  record['address']           = result.text.split("Address:")[1].split("[More]")[0].gsub("\r", " ").gsub("\n", " ").squeeze(' ').strip
  record['description']       = result.text.split("\r\n")[3].squeeze(' ').strip
  record['info_url']          = base_url + result.css('a')[0]['href'].split("/Pages/XC.Track/")[1]
  record['date_scraped']      = Date.today.to_s
  record['date_received']     = Date.strptime(result.text.split("Lodged:")[1].split("Applicant")[0].squeeze("\r\n ").strip, '%d/%m/%Y').to_s

  # Saving data to DB
  puts "Saving record " + record['council_reference'] + ", " + record['address']
  # puts record
  ScraperWiki.save_sqlite(['council_reference'], record)
end
