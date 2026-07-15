class FixLakshmiNarayanTempleName < ActiveRecord::Migration[8.1]
  # The deployed record spells the name as one unbreakable word
  # ("Laxminarayan Temple"), which cannot wrap inside the heading column
  # and overlaps the description (Figma 3249-15549 writes it as three
  # lines: Lakshmi / Narayan / Temple).
  def up
    block = ContentBlock.find_by(key: "monuments")
    return unless block && block.data.is_a?(Array)

    record = block.data.find { |m| m["id"] == "lakshmi-narayan-temple" }
    return unless record && record["name"].to_s =~ /Laxmi\s*narayan/i

    record["name"] = "Lakshmi Narayan Temple"
    block.update!(data: block.data)
  end

  def down; end
end
