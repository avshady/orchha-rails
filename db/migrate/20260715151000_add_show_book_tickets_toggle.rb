class AddShowBookTicketsToggle < ActiveRecord::Migration[8.1]
  # CMS toggle for the in-page Book Tickets button. The field must exist on
  # each record/section for the admin editors (which derive their forms from
  # the data) to offer it. Defaults to visible; Sundar Mahal starts hidden per
  # the client's request. Deployed content_blocks predate the field and seeds
  # never overwrite existing rows.
  PAGE_SECTIONS = %w[ecoTrailPage riverKayakingPage soundLightShowPage].freeze

  def up
    if (block = ContentBlock.find_by(key: "monuments"))
      data = block.data
      data.each do |monument|
        next if monument.key?("showBookTickets")
        monument["showBookTickets"] = monument["id"] != "sundar-mahal"
      end
      block.update!(data: data)
    end

    PAGE_SECTIONS.each do |key|
      block = ContentBlock.find_by(key: key)
      next if block.nil? || block.data.key?("showBookTickets")
      block.update!(data: block.data.merge("showBookTickets" => true))
    end
  end

  def down; end
end
