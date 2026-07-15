class RiverKayakingTwoWriteupsPerFigma < ActiveRecord::Migration[8.1]
  # The River Kayaking page now matches Figma 3261-7802: a rafting write-up
  # with its own Price/Timings card plus a boat-ride write-up with its own
  # Price/Best-time card, and a seasonal footnote. Deployed copy is replaced
  # with the copy the client supplied in the Figma.
  FIELDS = {
    "text1"          => "Enjoy beginner-friendly rafting on Grade I–II rapids, ideal for families, first-time rafters and adventure enthusiasts seeking a scenic river experience.\nDuration: Approx. 1–1.5 hours",
    "raftPrice"      => "Approx. ₹550 – ₹2,000 per person",
    "raftTimings"    => "Typically 10:00 AM – 4:00 PM",
    "raftPassengers" => "Upto 6 persons per raft",
    "text2"          => "Relax with a tranquil boat ride along the Betwa River and witness breathtaking views of Orchha's iconic chhatris and riverside heritage.",
    "cost"           => "Approx. ₹100 – ₹500",
    "bestTime"       => "Sunrise & Sunset",
    "passengers"     => "4–8 persons",
    "note"           => "*October to March is considered the ideal time to enjoy river activities in Orchha. Activities are subject to weather conditions and river water levels."
  }.freeze

  def up
    block = ContentBlock.find_by(key: "riverKayakingPage")
    return unless block

    block.update!(data: block.data.merge(FIELDS))
  end

  def down; end
end
