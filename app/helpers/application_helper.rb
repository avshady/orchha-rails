module ApplicationHelper
  # Normalize a CMS paragraph entry to its HTML string. Tolerates both the
  # plain-string format and the legacy rich-text hash ({ "type", "text" } or
  # { "html"/"body" }), so an older DB row can't render as a raw hash inspect.
  def paragraph_html(para)
    case para
    when String then para
    when Hash   then (para["text"] || para["html"] || para["body"] || para["content"]).to_s
    else para.to_s
    end
  end
end
