collection @places
attributes :code, :published_status, :name, :to_latlon
node(:sources) { |p| p.sources.size }
node(:has_instagram_source) { |p| p.has_instagram_source? }