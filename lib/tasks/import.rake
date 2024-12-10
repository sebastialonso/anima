require 'csv'
require 'pry'
require 'optparse'

namespace :import do
  desc "Imports counties from CSV to Postgis-compliant table"
  task counties: :environment do
    raw_counties = []
    
    filename = "/myapp/dump_counties.csv"
    rename_map = {
      "comuna_code" => "code", "comuna" => "name", "provincia" => "raw_province", "region_1" => "region_display"
    }
    CSV.foreach(filename, headers: true) do |row|
      row = row.to_h.transform_keys(rename_map)
      raw_counties << row
    end
    
    # create counties from CSV-based arguments
    raw_counties.map do |county_args|
      County.new(county_args.except("fid", "region", "ine")).save
    end
  end

  desc "Imports animitas from CSV to Postgis-compliant table"
  task :animitas, [:filename] => [:environment] do |_, args|
    options = {}
    opts = OptionParser.new
    opts.banner = "Usage: rake import:animitas -- --filename PATH"
    opts.on("-f", "--filename ARG", String) { |name| options[:filename] = name }
    args = opts.order!(ARGV) {}
    opts.parse!(args)

    raw_places = []
    
    CSV.foreach(options[:filename], encoding: "utf-8", headers: true, liberal_parsing: true) do |row|
      raw_places << row
    end
    
    c = 0
    raw_places.each_with_index do |data, idx|

      # Build place
      p = Place.new(name: data["name"], notes: data["notes"], lonlat: "POINT(#{data["longitude"]}  #{data["latitude"]})")

      # Build sources based of sources fields
      p.sources.new(kind: data["source"], link: data["source_link"], description: data["source_description"])
      
      # Build sources reading special strings in the "notes" column
      if !data["notes"].nil?
        notes_based_sources = Source.build_args_from_str data["notes"]
        notes_based_sources.each do |source|
          p.sources.new(source)
        end
      end
      
      begin
        if !p.save
          p "data in line #{idx + 2} has issues"
          p p.errors
        else
          c += 1
        end
      rescue ActiveRecord::NotNullViolation => e
        p "Error in line #{idx + 2}"
        p e.message
      end
    end

    p "#{c} created"
  end
end