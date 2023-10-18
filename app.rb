require 'bundler'
Bundler.require

$: .unshift File.expand_path("./../lib", __FILE__)
require_relative './lib/app/scrapper'

json_scrapper = Scrapper.new("http://annuaire-des-mairies.com/val-d-oise.html")


def save_to_json(data, file_path)
    File.open(file_path, 'w') do |file|
      file.puts JSON.pretty_generate(data)
    end
  end

def save_to_csv(data, file_path)
    CSV.open(file_path, 'w') do |csv|
      # Écrit les en-têtes (noms de colonnes) dans le fichier CSV
      csv << data.first.keys
  
      # Écrit les données dans le fichier CSV
      data.each { |row| csv << row.values }
    end
end
  


directory_data = json_scrapper.get_directory


puts directory_data.inspect

save_to_json(directory_data, './db/emails.json')

save_to_json(directory_data, './db/emails.csv')


