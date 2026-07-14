class RefreshArtWalkPageImages < ActiveRecord::Migration[8.1]
  # Data fix for the deployed content_blocks row (seeds never overwrite):
  # Figma 3265-6642 uses dedicated photos for the Walk Through Time stops
  # and a rounded fresco card instead of the old faded vignette. Only swap
  # paths that still point at the old files so admin edits are preserved.
  STOP_SWAPS = {
    "/images/rm_closeup_main.jpg"  => "/images/aw_stop1.jpg",
    "/images/jm_closeup_main.jpg"  => "/images/aw_stop2.jpg",
    "/images/rpm_closeup_main.jpg" => "/images/aw_stop3.jpg",
    "/images/lnt_closeup_main.jpg" => "/images/aw_stop4.jpg"
  }.freeze

  def up
    block = ContentBlock.find_by(key: "artWalkPage")
    return unless block

    data = block.data
    data["vignetteImage"] = "/images/aw_walkcard.jpg" if data["vignetteImage"] == "/images/aw_vignette.jpg"
    if data["stops"].is_a?(Array)
      data["stops"].each do |stop|
        next unless stop.is_a?(Hash)

        stop["image"] = STOP_SWAPS.fetch(stop["image"], stop["image"])
      end
    end
    block.update!(data: data)
  end

  def down; end
end
