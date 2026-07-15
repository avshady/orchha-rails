class AddExtendedItineraries < ActiveRecord::Migration[8.1]
  # Plan Your Visit grows 4/5/6-day itineraries. Seeds never overwrite
  # existing rows, so copy the new days from content.json into the deployed
  # itineraries row (only days that don't exist yet — admin edits preserved)
  # and extend the day labels when they're still the old three-step set.
  def up
    seed_path = Rails.root.join("content.json")
    return unless File.exist?(seed_path)

    seed = JSON.parse(File.read(seed_path))

    if (block = ContentBlock.find_by(key: "itineraries"))
      data = block.data
      if data.is_a?(Hash)
        %w[day-4 day-5 day-6].each do |day|
          data[day] = seed.dig("itineraries", day) if data[day].blank? && seed.dig("itineraries", day).present?
        end
        block.update!(data: data)
      end
    end

    if (page = ContentBlock.find_by(key: "planYourVisitPage"))
      data = page.data
      if data.is_a?(Hash) && Array(data["dayLabels"]).length <= 3
        data["dayLabels"] = seed.dig("planYourVisitPage", "dayLabels")
        page.update!(data: data)
      end
    end
  end

  def down; end
end
