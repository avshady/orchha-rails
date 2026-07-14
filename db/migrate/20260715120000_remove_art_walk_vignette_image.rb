class RemoveArtWalkVignetteImage < ActiveRecord::Migration[8.1]
  # The photo card under "The Walk Through Time" was removed from the page;
  # drop its field from the deployed content row so the CMS form no longer
  # offers it (admin forms derive their fields from the stored data).
  def up
    block = ContentBlock.find_by(key: "artWalkPage")
    return unless block

    data = block.data
    return unless data.is_a?(Hash) && data.key?("vignetteImage")

    data.delete("vignetteImage")
    block.update!(data: data)
  end

  def down; end
end
