module HohoHelper
  # Small inline icon set for HOHO service feature tags, keyed by label
  # (case-insensitive). Falls back to a generic check icon.
  HOHO_FEATURE_ICONS = {
    "comfortable" => '<svg viewBox="0 0 28 28" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M6 16v-3a3 3 0 0 1 3-3h10a3 3 0 0 1 3 3v3" stroke="#6e1603" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/><path d="M4 16h20v3a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-3Z" stroke="#6e1603" stroke-width="1.6" stroke-linejoin="round"/><path d="M6 21v2M22 21v2" stroke="#6e1603" stroke-width="1.6" stroke-linecap="round"/></svg>',
    "spacious" => '<svg viewBox="0 0 28 28" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M4 4h7M4 4v7M4 4l8 8M24 4h-7M24 4v7M24 4l-8 8M4 24h7M4 24v-7M4 24l8-8M24 24h-7M24 24v-7M24 24l-8-8" stroke="#6e1603" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/></svg>',
    "eco-friendly" => '<svg viewBox="0 0 28 28" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M6 22C4 14 9 5 22 5c1 8-4 17-16 17Z" stroke="#6e1603" stroke-width="1.6" stroke-linejoin="round"/><path d="M6 22c3-6 7-10 15-15" stroke="#6e1603" stroke-width="1.6" stroke-linecap="round"/></svg>',
    "quick" => '<svg viewBox="0 0 28 28" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M15 3 5 16h7l-2 9 11-14h-7l1-8Z" stroke="#6e1603" stroke-width="1.6" stroke-linejoin="round"/></svg>',
    "convenient" => '<svg viewBox="0 0 28 28" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M8 12V7a2 2 0 0 1 4 0v5M12 11V5a2 2 0 0 1 4 0v6M16 11.5V6a2 2 0 0 1 4 0v9c0 4.5-3 8-8 8s-7-2.5-8.5-6L2 13a1.8 1.8 0 0 1 3-2l2 2.5" stroke="#6e1603" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/></svg>'
  }.freeze

  DEFAULT_ICON = '<svg viewBox="0 0 28 28" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M5 14.5 11 20 23 7" stroke="#6e1603" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/></svg>'.freeze

  def hoho_feature_icon(label)
    raw(HOHO_FEATURE_ICONS[label.to_s.downcase] || DEFAULT_ICON)
  end
end
