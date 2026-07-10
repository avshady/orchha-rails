class Page < ApplicationRecord
  # Slugs that belong to real routes and can never be claimed by a custom page.
  RESERVED_SLUGS = %w[
    admin session up rails assets images fonts videos
    history monuments accommodation events sabhyata experiences
  ].freeze

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true,
    format: { with: /\A[a-z0-9]+(-[a-z0-9]+)*\z/, message: "must be lowercase letters, numbers and hyphens" },
    exclusion: { in: RESERVED_SLUGS, message: "is reserved by the site" }

  scope :published, -> { where(published: true) }
end
