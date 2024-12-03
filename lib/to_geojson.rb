require 'csv'

class ToGeoJSON
  CONSTANT_FEATURE_COLLECTION = "FeatureCollection"
  COLUMNS = ["name", "source", "source_link", "latitude", "longitude", "point_syntax", "commune", "kind", "certainty", "notes"]

  def initialize filepath
    @filepath = filepath
  end

  def open
    CSV.read(@filepath)
  end

  def columns_allowed
    ["name", "source", "source_link", "latitude", "longitude", "kind", "certainty"]
  end

  def run
    rows = open()
    diff = COLUMNS - rows[0]
    if diff.size > 0
      raise ArgumentError.new("Headers from CSV or the script are not consistent!: #{diff}") if COLUMNS.sort != rows[0]
    end
    
    features = rows[1..].map do |row|
      build_single_feature(row)
    end
    b = build_base
    b["features"] = features
    
    write b
  end

  def build_base
    {
      "type" => CONSTANT_FEATURE_COLLECTION,
      "features" => []
    }
  end

  def build_single_feature arr
    base = {
      "type" => "Feature",
      "geometry" => {
        "type" => "Point",
        "coordinates" => [0,0]
      },
      "properties" => {

      }
    }

    properties = {}
    field_allowed = ->(x) { columns_allowed.include? x }
    COLUMNS.each_with_index do |val, idx|
      case val
      when "latitude"
        base["geometry"]["coordinates"][1] = arr[idx].to_f
      when "longitude"
        base["geometry"]["coordinates"][0] = arr[idx].to_f
      when "certainty"
        if [nil, "FALSE"].include?(arr[idx])
          properties[val] = arr[idx] == "FALSE" ? false : true
        else
          p "CERTAINTY: #{arr[idx]}"
          properties[val] = "ERROR"
        end
      when field_allowed
        properties[val] = arr[idx]
      else
        next
      end
    end

    base["properties"] = properties
    base
  end

  def write hash
    File.open('/myapp/geo.json', 'w') do |f|
      f.write(hash.to_json)
    end
  end
end