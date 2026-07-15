class RenameTrailsToWalks < ActiveRecord::Migration[8.1]
  # Site-wide copy change: "trail(s)" becomes "walk(s)" in user-visible text.
  # Also merges the TRAILS filter into WALKS on the Experiences page and
  # points the home page's dead /trails/* links at the real experience pages.
  # Applied to every content block because seeds never overwrite existing rows.
  TEXT_KEYS = %w[name title label heading subheading subtitle description
                 text1 text2 text3 outroCtaLabel body].freeze

  LINK_SWAPS = {
    "/trails/citadel"    => "/experiences/citadel-walk",
    "/trails/religious"  => "/experiences/religious-walk",
    "/trails/ecological" => "/experiences/eco-trail",
    "/trails/art"        => "/experiences/art-walk",
    "/trails"            => "/experiences"
  }.freeze

  def word_swap(text)
    text.gsub("Eco Trail Nature Walk", "Eco Nature Walk")
        .gsub("walking trails", "walks")
        .gsub(/\bTrails\b/, "Walks").gsub(/\bTrail\b/, "Walk")
        .gsub(/\btrails\b/, "walks").gsub(/\btrail\b/, "walk")
        .gsub("walking walks", "walks")
  end

  def prose?(str)
    str.is_a?(String) && !str.include?("/") && !str.include?("Website Assets")
  end

  def transform(node, key = nil)
    case node
    when Hash
      out = node.each_with_object({}) { |(k, v), h| h[k] = transform(v, k) }
      out["category"] = "walks" if out["category"] == "trails"
      out["link"]    = LINK_SWAPS.fetch(out["link"], out["link"])    if out["link"].is_a?(String)
      out["ctaLink"] = LINK_SWAPS.fetch(out["ctaLink"], out["ctaLink"]) if out["ctaLink"].is_a?(String)
      out
    when Array
      arr = node.map { |v| transform(v, key) }
      if key == "filterCategories"
        arr.reject! { |c| c.is_a?(Hash) && c["value"] == "trails" }
      end
      arr
    when String
      if prose?(node) && (TEXT_KEYS.include?(key) || key == "paragraphs")
        word_swap(node)
      else
        node
      end
    else
      node
    end
  end

  def up
    ContentBlock.find_each do |block|
      transformed = transform(block.data)
      block.update!(data: transformed) unless transformed == block.data
    end
  end

  def down; end
end
