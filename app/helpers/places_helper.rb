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

  def get_humanized_status place
    case place.status
    when Place::STATUS_ACTIVE
      "Activa"
    when Place::STATUS_DAMAGED
      "Dañada/Abandonada"
    when Place::STATUS_GONE
      "Desaparecida"
    else
      "Estado no válido"
    end
  end

  def get_status_text place
    case place.status
    when Place::STATUS_ACTIVE
      "La animita está en buen estado"
    when Place::STATUS_DAMAGED
      "La animita tiene daños o ha sido abandonada"
    when Place::STATUS_GONE
      "La animita no está en el último lugar reportado"
    else
      "Estado no válido"
    end
  end

  def get_published_status_text place
    case place.published_status
    when Place::PUBLISHED_STATUS_ACCEPTED
      "Publicada"
    when Place::PUBLISHED_STATUS_IN_REVIEW
      "En revisión"
    when Place::PUBLISHED_STATUS_REJECTED
      "Rechazada"
    else
      "Estado no válido"
    end
  end

  def get_humanized_published_status place
    case place.published_status
    when Place::PUBLISHED_STATUS_ACCEPTED
      "La entrada ha sido aprobada y publicada"
    when Place::PUBLISHED_STATUS_IN_REVIEW
      "La entrada se encuentra en revisión"
    when Place::PUBLISHED_STATUS_REJECTED
      "La entrada ha sido rechazada porque no entrega información nueva o relevante"
    else
      "Estado no válido"
    end
  end
end
