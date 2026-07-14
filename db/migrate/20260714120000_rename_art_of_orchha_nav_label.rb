class RenameArtOfOrchhaNavLabel < ActiveRecord::Migration[8.1]
  # Data fix: the deployed content_blocks row for homePage predates this label
  # change, and seeds never overwrite existing rows.
  def up
    block = ContentBlock.find_by(key: "homePage")
    return unless block

    items = block.data.dig("nav", "discoverDropdown")
    return unless items.is_a?(Array)

    changed = false
    items.each do |item|
      next unless item.is_a?(Hash) && item["label"].to_s.include?("Frescoes")

      item["label"] = "Art of Orchha"
      changed = true
    end
    block.save! if changed
  end

  def down; end
end
