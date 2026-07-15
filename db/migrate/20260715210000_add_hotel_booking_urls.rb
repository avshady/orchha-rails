class AddHotelBookingUrls < ActiveRecord::Migration[8.1]
  # Hotel cards' Book Now buttons open each hotel's own booking page.
  # Verified official URLs are filled in; the rest get an empty bookUrl
  # (button hidden) until the client supplies links via the CMS. Never
  # overwrites a URL an admin has already set.
  URLS = {
    "mpt-betwa-retreat" => "https://mpstdc.mponline.gov.in/hotel-in-city-orchha/mpt-betwa-retreat-orchha",
    "mpt-sheesh-mahal"  => "https://mpstdc.mponline.gov.in/hotel-in-city-orchha/mpt-sheesh-mahal-orchha",
    "orchha-resort"     => "https://www.orchharesort.com",
    "amar-mahal"        => "https://www.amarmahal.com"
  }.freeze

  def up
    block = ContentBlock.find_by(key: "accommodations")
    return unless block && block.data.is_a?(Array)

    data = block.data
    data.each do |rec|
      next unless rec.is_a?(Hash)

      rec["bookUrl"] = "" unless rec.key?("bookUrl")
      rec["bookUrl"] = URLS[rec["id"]] if URLS[rec["id"]] && rec["bookUrl"].blank?
    end
    block.update!(data: data)
  end

  def down; end
end
