require "icon_scraper"

IconScraper.scrape_with_params(
  url: "http://eplanning.cumberland.nsw.gov.au/Pages/XC.Track/SearchApplication.aspx",
  period: "last14days"
) do |record|
  record["address"] = record["address"].gsub(",", "")

  IconScraper.save(record)
end
