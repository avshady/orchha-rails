class RefreshEcoTrailPageContent < ActiveRecord::Migration[8.1]
  # Data fix for the deployed content_blocks row (seeds never overwrite):
  # Figma 3265-7019 copy corrections (Panchmadhi / riverside huts, lead line
  # break) and the new second Did-You-Know image.
  def up
    block = ContentBlock.find_by(key: "ecoTrailPage")
    return unless block

    data = block.data
    if data["paragraphs"].is_a?(Array)
      data["paragraphs"] = data["paragraphs"].map do |para|
        next para unless para.is_a?(String)

        para.sub("Just beyond the monuments, the forest begins. The",
                 "Just beyond the monuments, the forest begins.\nThe")
            .gsub("Panchnadhi", "Panchmadhi")
            .gsub("five riverside bats", "five riverside huts")
      end
    end
    data["dykImage2"] ||= "/images/et_card4.jpg"
    # The Figma-correct photos ship under versioned names because public/ is
    # served with a 1-year cache; only swap paths still pointing at the old files.
    { "cardImage1" => %w[/images/et_card1.jpg /images/et_card1_v2.jpg],
      "cardImage2" => %w[/images/et_card2.jpg /images/et_card2_v2.jpg],
      "dykImage"   => %w[/images/et_card3.jpg /images/et_card3_v2.jpg],
      "outroImage" => %w[/images/et_outro.jpg /images/et_outro_v2.jpg] }.each do |field, (old_path, new_path)|
      data[field] = new_path if data[field] == old_path
    end
    block.update!(data: data)
  end

  def down; end
end
