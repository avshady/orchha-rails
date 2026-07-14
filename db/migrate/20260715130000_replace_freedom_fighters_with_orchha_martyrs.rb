class ReplaceFreedomFightersWithOrchhaMartyrs < ActiveRecord::Migration[8.1]
  # Content change requested by the client: the five Freedom Fighters cards
  # become the five Orchha-region martyrs (English names, Hindi originals
  # kept in nameHindi). Seeds never overwrite existing rows, so the deployed
  # collection is replaced from the current content.json here. Photos are a
  # dignified placeholder until real portraits are supplied via the CMS.
  def up
    block = ContentBlock.find_by(key: "freedomFighters")
    return unless block

    seed_path = Rails.root.join("content.json")
    return unless File.exist?(seed_path)

    seed = JSON.parse(File.read(seed_path))["freedomFighters"]
    block.update!(data: seed) if seed.is_a?(Array) && seed.any?
  end

  def down; end
end
