module PlacesHelper
  NO_DATA = "No hay información disponible"
  def get_name place
    place.name || NO_DATA
  end

  def get_lead_name place
    st = {
      code: "#{place.code}"
    }
    if !place.name.blank?
      st[:name] = " - #{place.name}"  
    end
    st
  end

  def get_decimal_degrees place
    "(#{place.lonlat.y}, #{place.lonlat.x})"
  end

  def get_wkt place
    place.lonlat.to_s
  end

  def link_to_google_maps place
    "https://www.google.com/maps/?q=#{place.lonlat.y},#{place.lonlat.x}"
  end

  def get_description place
    NO_DATA
  end

  def get_county_info place
    county = County.where(code: place.code[0..3]).first
    region = "#{county.region_display} región"
    if county.region_display == "XIII"
      region = "Región RM"
    end
    return "#{county.name.titleize} - #{region}" if !county.nil?
    return NO_DATA
  end

  def get_subject place
    place.subject || NO_DATA
  end

  def get_date_info place
    place.date_info || NO_DATA
  end

  def humanize_source_name source
    case source.kind
    when Source::KIND_GOOGLE_STREETVIEW
      "Punto en Google Street View"
    when Source::KIND_INSTAGRAM
      "Post en Instagram"
    when Source::KIND_DIA
      "Declaración de Impacto Ambiental - Servicio de Evaluación Ambiental"
    else
      "Fuente no reconocida"
    end
  end

  def get_created_at place
    place.created_at.strftime("%d-%m-%Y %H:%M")
  end

  def get_modified_at place
    place.updated_at.strftime("%d-%m-%Y %H:%M")
  end
end
