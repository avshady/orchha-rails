class ExpandExtendedItineraries < ActiveRecord::Migration[8.1]
  # Days 4-6 grew from three cards to five richer ones. Refresh the deployed
  # rows from content.json, but only while they still hold the short
  # first-cut versions (3 cards or fewer) so admin-authored plans survive.
  def up
    seed_path = Rails.root.join("content.json")
    return unless File.exist?(seed_path)

    seed = JSON.parse(File.read(seed_path))
    block = ContentBlock.find_by(key: "itineraries")
    return unless block && block.data.is_a?(Hash)

    data = block.data
    %w[day-4 day-5 day-6].each do |day|
      next unless Array(data[day]).length <= 3 && seed.dig("itineraries", day).present?

      data[day] = seed["itineraries"][day]
    end
    block.update!(data: data)
  end

  def down; end
end
