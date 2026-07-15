class AddFooterVirtualTourUrl < ActiveRecord::Migration[8.1]
  # The site-wide footer gained an "Orchha Virtual Tour" button whose URL is
  # editable at Home -> Page Content -> footer -> virtualTourUrl. Deployed
  # content_blocks predate the field and seeds never overwrite existing rows.
  def up
    block = ContentBlock.find_by(key: "homePage")
    return unless block

    footer = block.data["footer"]
    return unless footer.is_a?(Hash)
    return if footer.key?("virtualTourUrl")

    footer["virtualTourUrl"] = "#"
    block.save!
  end

  def down; end
end
