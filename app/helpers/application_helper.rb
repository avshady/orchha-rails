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

  # CMS media fields accept either an image or a video path.
  def video_path?(src)
    src.to_s.match?(/\.(mp4|webm|mov|m4v)(\?|\z)/i)
  end

  # Renders a hero/backdrop medium: <video> for video paths, <img> otherwise.
  # Extra html attributes (class, style, alt, ...) apply to either tag.
  def hero_media_tag(src, alt: "", **attrs)
    if video_path?(src)
      content_tag(:video, autoplay: true, muted: true, loop: true, playsinline: true, "data-sound-video": "", **attrs) do
        tag(:source, src: src, type: "video/mp4")
      end
    else
      image_tag(src, alt: alt, **attrs)
    end
  end
end
