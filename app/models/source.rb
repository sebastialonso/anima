class Source < ApplicationRecord
  belongs_to :place

  KIND_GOOGLE_STREETVIEW = "GOOGLE_STREET_VIEW"
  KIND_INSTAGRAM = "INSTAGRAM"
  KIND_DIA = "SEIA_DIA"
  KIND_ALLOWED = [KIND_GOOGLE_STREETVIEW, KIND_INSTAGRAM, KIND_DIA]
  
  LINK_INSTAGRAM_REGEX = /insta::(?<url>https\:\/+www\.instagram\.com\/p\/\w+\/)::/
  LINK_GSTREET_VIEW_REGEX = /gstreet::(?<url>https\:\/+www\.google\.com\/maps\/\@.*)::/
  validates :kind, inclusion: { in: KIND_ALLOWED }
  validates :link, presence: true, if: -> { [KIND_GOOGLE_STREETVIEW, KIND_INSTAGRAM, KIND_DIA].include? kind }

  class << self
    def build_args_from_str str
      enabled_patterns = {insta: LINK_INSTAGRAM_REGEX, gstreet: LINK_GSTREET_VIEW_REGEX}

      return enabled_patterns.map do |source_slug, pattern|
        match = str.match(pattern)
        if !match.nil?
          computed_kind = self.get_kind_from_slug(source_slug)
          {kind: computed_kind, link: match.named_captures["url"]} if KIND_ALLOWED.include?(computed_kind)
        end
      end.compact
    end

    def get_kind_from_slug slug
      case slug
      when :insta
        KIND_INSTAGRAM
      when :gstreet
        KIND_GOOGLE_STREETVIEW
      else
        nil
      end
    end
  end

  def is_geographic?
    kind == KIND_GOOGLE_STREETVIEW || kind == KIND_DIA
  end
end
