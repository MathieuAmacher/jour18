require 'nokogiri'
require 'open-uri'

class Scrapper
  def initialize(directory_url)
    @directory_url = directory_url
  end

  def do_scrape(url)
    Nokogiri::HTML(URI.open(url))
  end

  def get_townhall_email(townhall_url)
    transformed_url = "http://annuaire-des-mairies.com" + townhall_url[1..99999]
    
    html = do_scrape(transformed_url)

    mail_xpath = html.xpath("//*[text()[contains(., 'Adresse Email')]]/following-sibling::td")

    mail_xpath.text
  end

  def get_townhall_urls
    html = do_scrape(@directory_url)
    html.xpath("//table[@class='Style20']//a")
  end

  def get_directory
    directory = []

    get_townhall_urls.each do |townhall|
      townhall_name = townhall.text()
      townhall_url = townhall["href"]
      townhall_email = get_townhall_email(townhall_url)

      directory << { townhall_name => townhall_email }
    end

    puts directory
    directory
  end
end