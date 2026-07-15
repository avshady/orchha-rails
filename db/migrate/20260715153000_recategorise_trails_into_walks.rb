class RecategoriseTrailsIntoWalks < ActiveRecord::Migration[8.1]
  # The client re-branded "Experiences & Trails" as "Experiences & Walks":
  # the TRAILS filter merges into WALKS on the listing page and the nav
  # dropdown label changes. Deployed content_blocks predate this and seeds
  # never overwrite existing rows.
  def up
    if (block = ContentBlock.find_by(key: "homePage"))
      items = block.data.dig("nav", "discoverDropdown")
      if items.is_a?(Array)
        items.each do |item|
          next unless item.is_a?(Hash) && item["label"].to_s.include?("Experiences")
          item["label"] = "Experiences & Walks"
        end
        block.save!
      end
    end

    if (block = ContentBlock.find_by(key: "experiencesPage"))
      data = block.data
      data["heading"] = "Experiences & Walks" if data["heading"].to_s.match?(/Experiences (and|&) Trails/i)
      cats = data["filterCategories"]
      if cats.is_a?(Array)
        data["filterCategories"] = cats.reject { |c| c.is_a?(Hash) && c["value"] == "trails" }
      end
      block.update!(data: data)
    end

    if (block = ContentBlock.find_by(key: "experienceItems"))
      data = block.data
      data.each { |item| item["category"] = "walks" if item.is_a?(Hash) && item["category"] == "trails" }
      block.update!(data: data)
    end
  end

  def down; end
end
