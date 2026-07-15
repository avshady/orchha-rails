class PointVisitLinksAtVisitOrchhaPage < ActiveRecord::Migration[8.1]
  # The "Visit Orchha" band links were temporarily pointed at the external
  # visit-orchha.netlify.app placeholder before the in-site /visit-orchha
  # page existed. Rewrite any remaining netlify URLs across all content
  # blocks to the internal pages (Stay Options goes to /accommodation).
  NETLIFY_PREFIX = "https://visit-orchha.netlify.app".freeze

  def up
    ContentBlock.find_each do |block|
      data = block.data
      next unless rewrite!(data)

      block.update!(data: data)
    end
  end

  def down; end

  private

  # Returns true if anything changed.
  def rewrite!(node)
    case node
    when Hash
      changed = false
      if node["url"].to_s.start_with?(NETLIFY_PREFIX)
        node["url"] = node["label"].to_s.match?(/stay/i) ? "/accommodation" : "/visit-orchha"
        changed = true
      end
      node.each_value { |v| changed = true if rewrite!(v) }
      changed
    when Array
      node.map { |v| rewrite!(v) }.any?
    else
      false
    end
  end
end
