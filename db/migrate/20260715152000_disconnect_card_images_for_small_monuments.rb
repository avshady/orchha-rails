class DisconnectCardImagesForSmallMonuments < ActiveRecord::Migration[8.1]
  # Sundar Mahal, Hanuman Mandir, and Sheesh Mahal reused their listing-card
  # image inside the detail page via fallbacks. Give them their own editable
  # heroImage/detailImage (seeded from the card image, so nothing changes
  # visually) plus an empty galleryImages list for extra CMS photos.
  TARGETS = %w[sundar-mahal hanuman-mandir sheesh-mahal].freeze

  def up
    block = ContentBlock.find_by(key: "monuments")
    return unless block

    data = block.data
    data.each do |m|
      next unless TARGETS.include?(m["id"])

      card = m["image"].to_s
      m["heroImage"]     = card if m["heroImage"].to_s.empty?
      m["detailImage"]   = card if m["detailImage"].to_s.empty?
      m["galleryImages"] ||= []
    end
    block.update!(data: data)
  end

  def down; end
end
