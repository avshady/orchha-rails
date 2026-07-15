class AddEventDetailFields < ActiveRecord::Migration[8.1]
  # Event detail pages (Figma 3272-13548) show a description, hero,
  # estimated visitors, and an Archived Gallery carousel. Adds the fields to
  # every deployed event record so the CMS form offers them; New Year
  # Celebrations gets the copy supplied in the Figma.
  NYE_DESC = "The New Year period brings a vibrant festive atmosphere to Orchha, " \
             "with visitors gathering at temples, heritage sites and the Betwa " \
             "riverfront for prayers, evening aartis and cultural experiences.".freeze

  def up
    block = ContentBlock.find_by(key: "events")
    return unless block

    data = block.data
    data.each do |ev|
      ev["heroImage"]         = "" unless ev.key?("heroImage")
      ev["description"]       = "" unless ev.key?("description")
      ev["estimatedVisitors"] = "" unless ev.key?("estimatedVisitors")
      ev["galleryImages"]   ||= []

      if ev["id"] == "new-year-celebrations"
        ev["description"]       = NYE_DESC if ev["description"].to_s.empty?
        ev["estimatedVisitors"] = "~1,00,000 Annually" if ev["estimatedVisitors"].to_s.empty?
      end
    end
    block.update!(data: data)
  end

  def down; end
end
