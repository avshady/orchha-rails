class RestoreArtWalkVignetteImage < ActiveRecord::Migration[8.1]
  # The client asked for the image below "The Walk Through Time" back
  # (CMS-managed, working asset now in place). Re-adds the field to the
  # deployed artWalkPage row so the admin form offers it again.
  def up
    block = ContentBlock.find_by(key: "artWalkPage")
    return unless block

    data = block.data
    return if data.key?("vignetteImage")

    data["vignetteImage"] = "/images/aw_walkcard.jpg"
    block.update!(data: data)
  end

  def down; end
end
