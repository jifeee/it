namespace :import do
  desc "Parses all shipments data from the files"
  task :shipments => :environment do
    Parser.new(:file_name => "SampleEDI214.txt")
  end
end
