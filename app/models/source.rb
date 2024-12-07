class Source < ApplicationRecord
  belongs_to :place

  KIND_GOOGLE_STREETVIEW = "GOOGLE_STREET_VIEW"
  KIND_INSTAGRAM = "INSTAGRAM"
  KIND_ALLOWED = [KIND_GOOGLE_STREETVIEW, KIND_INSTAGRAM]
  
  LINK_INSTAGRAM_REGEX = /insta::(?<url>\w+\:\/+\w+\.\w+\.\w+\/\w+\/\w+\/)::/
  validates :kind, inclusion: { in: KIND_ALLOWED }
  validates :link, presence: true, if: -> { [KIND_GOOGLE_STREETVIEW, KIND_INSTAGRAM].include? kind }

  def is_geographic?
    kind == KIND_GOOGLE_STREETVIEW
  end
end
