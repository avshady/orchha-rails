module AdminHelper
  # Friendly names for content block keys.
  KEY_LABELS = {
    "homePage"          => "Home Page",
    "historyPage"       => "History Page",
    "monumentsPage"     => "Monuments Page Settings",
    "monuments"         => "Monuments",
    "experiencesPage"   => "Experiences Page Settings",
    "experienceItems"   => "Experiences & Walks",
    "cuisineItems"      => "Cuisine Items",
    "eventsPage"        => "Events Page Settings",
    "events"            => "Events",
    "accommodationPage" => "Accommodation Page Settings",
    "accommodations"    => "Hotels & Homestays",
    "soundLightShowPage" => "Light & Sound Show Page",
    "citadelWalkPage"   => "Citadel Walk Page",
    "artWalkPage"       => "Art Walk Page",
    "ecoTrailPage"      => "Eco Trail Page",
    "riverKayakingPage" => "River Kayaking Page",
    "sunsetBetwaPage"   => "Sunset At Betwa Page",
    "religiousWalkPage" => "Religious Walk Page",
    "supportUsPage"     => "Support Us Page Settings",
    "sabhyataPage"      => "Sabhyata Foundation Page",
    "planYourVisitPage" => "Plan Your Visit Page Settings",
    "visitOrchhaPage"   => "Visit Orchha Page",
    "newsPage"          => "News Page Settings",
    "newsItems"         => "News",
    "museums"           => "Museums",
    "itineraries"       => "Itineraries",
    "freedomFighters"   => "Freedom Fighters",
    "hohoServices"      => "Hop-on Hop-off Services",
    "audioGuides"       => "Audio Guides",
    "artFrescoesPage"   => "Art of Orchha Page Settings",
    "artFrescoes"       => "Art of Orchha / Frescoes",
    "heroImages"        => "Hero Images",
    "journeyImages"     => "Journey Images",
    "homeTrails"        => "Home Trails",
    "experiences"       => "Home Experience Cards (legacy)",
    "settings"          => "Site Settings"
  }.freeze

  # Where a record in a collection goes live, if it has its own page.
  LIVE_PATHS = {
    "monuments"       => "/monuments",
    "events"          => "/events",
    "experienceItems" => "/experiences"
  }.freeze

  # Sidebar structure: groups of items. Each item points at a section editor
  # (hash key), a collection manager (array key), custom pages, or media.
  def admin_nav
    [
      { group: "Overview", items: [
        { label: "Dashboard", path: admin_root_path, match: %r{\A/admin\z} }
      ] },
      { group: "Pages", items: [
        { label: "Home", path: admin_edit_section_path("homePage"), match: %r{/(sections/homePage|admin/hero)},
          children: [
            { label: "Page Content", path: admin_edit_section_path("homePage"), match: %r{/sections/homePage} },
            { label: "Hero Slideshow", path: admin_edit_hero_path, match: %r{/admin/hero} }
          ] },
        { label: "History", path: admin_edit_section_path("historyPage"), match: %r{/sections/historyPage} },
        { label: "Monuments", path: admin_collection_path("monuments"), match: %r{/(collections|sections)/monuments},
          children: [
            { label: "All Monuments", path: admin_collection_path("monuments"), match: %r{/collections/monuments} },
            { label: "Page Settings", path: admin_edit_section_path("monumentsPage"), match: %r{/sections/monumentsPage} }
          ] },
        { label: "Experiences", path: admin_collection_path("experienceItems"), match: %r{/(collections/(experienceItems|cuisineItems)|sections/(experiencesPage|artWalkPage|ecoTrailPage|riverKayakingPage|religiousWalkPage|citadelWalkPage))},
          children: [
            { label: "All Experiences", path: admin_collection_path("experienceItems"), match: %r{/collections/experienceItems} },
            { label: "Art Walk Page", path: admin_edit_section_path("artWalkPage"), match: %r{/sections/artWalkPage} },
            { label: "Citadel Walk Page", path: admin_edit_section_path("citadelWalkPage"), match: %r{/sections/citadelWalkPage} },
            { label: "Eco Trail Page", path: admin_edit_section_path("ecoTrailPage"), match: %r{/sections/ecoTrailPage} },
            { label: "River Kayaking Page", path: admin_edit_section_path("riverKayakingPage"), match: %r{/sections/riverKayakingPage} },
            { label: "Religious Walk Page", path: admin_edit_section_path("religiousWalkPage"), match: %r{/sections/religiousWalkPage} },
            { label: "Sunset At Betwa Page", path: admin_edit_section_path("sunsetBetwaPage"), match: %r{/sections/sunsetBetwaPage} },
            { label: "Cuisine Items", path: admin_collection_path("cuisineItems"), match: %r{/collections/cuisineItems} },
            { label: "Page Settings", path: admin_edit_section_path("experiencesPage"), match: %r{/sections/experiencesPage} }
          ] },
        { label: "Events", path: admin_collection_path("events"), match: %r{/(collections/events|sections/eventsPage)},
          children: [
            { label: "All Events", path: admin_collection_path("events"), match: %r{/collections/events\b} },
            { label: "Page Settings", path: admin_edit_section_path("eventsPage"), match: %r{/sections/eventsPage} }
          ] },
        { label: "Accommodation", path: admin_collection_path("accommodations"), match: %r{/(collections/accommodations|sections/accommodationPage)},
          children: [
            { label: "All Stays", path: admin_collection_path("accommodations"), match: %r{/collections/accommodations} },
            { label: "Page Settings", path: admin_edit_section_path("accommodationPage"), match: %r{/sections/accommodationPage} }
          ] },
        { label: "Light & Sound Show", path: admin_edit_section_path("soundLightShowPage"), match: %r{/sections/soundLightShowPage} },
        { label: "Plan Your Visit", path: admin_edit_section_path("planYourVisitPage"), match: %r{/(sections/planYourVisitPage|collections/itineraries)},
          children: [
            { label: "Page Content", path: admin_edit_section_path("planYourVisitPage"), match: %r{/sections/planYourVisitPage} },
            { label: "Itineraries", path: admin_collection_path("itineraries"), match: %r{/collections/itineraries} }
          ] },
        { label: "Visit Orchha", path: admin_edit_section_path("visitOrchhaPage"), match: %r{/sections/visitOrchhaPage} },
        { label: "Sabhyata Foundation", path: admin_edit_section_path("sabhyataPage"), match: %r{/sections/sabhyataPage} },
        { label: "Support Us", path: admin_edit_section_path("supportUsPage"), match: %r{/sections/supportUsPage} },
        { label: "Custom Pages", path: admin_pages_path, match: %r{/admin/pages} }
      ] },
      { group: "Content", items: [
        { label: "News", path: admin_collection_path("newsItems"), match: %r{/(collections/newsItems|sections/newsPage)},
          children: [
            { label: "All News", path: admin_collection_path("newsItems"), match: %r{/collections/newsItems} },
            { label: "Page Settings", path: admin_edit_section_path("newsPage"), match: %r{/sections/newsPage} }
          ] },
        { label: "Museums", path: admin_collection_path("museums"), match: %r{/collections/museums} },
        { label: "Freedom Fighters", path: admin_collection_path("freedomFighters"), match: %r{/collections/freedomFighters} },
        { label: "HOHO Services", path: admin_collection_path("hohoServices"), match: %r{/collections/hohoServices} },
        { label: "Audio Guides", path: admin_collection_path("audioGuides"), match: %r{/collections/audioGuides} },
        { label: "Art of Orchha / Frescoes", path: admin_collection_path("artFrescoes"), match: %r{/(collections/artFrescoes|sections/artFrescoesPage)},
          children: [
            { label: "All Frescoes", path: admin_collection_path("artFrescoes"), match: %r{/collections/artFrescoes} },
            { label: "Page Settings", path: admin_edit_section_path("artFrescoesPage"), match: %r{/sections/artFrescoesPage} }
          ] }
      ] },
      { group: "Library", items: [
        { label: "Media", path: admin_media_path, match: %r{/admin/media} },
        { label: "Site Settings", path: admin_edit_section_path("settings"), match: %r{/sections/settings} },
        { label: "Backup", path: admin_export_path, match: /never/ }
      ] }
    ]
  end

  def key_label(key)
    KEY_LABELS[key] || key
  end

  # Friendly labels for individual fields inside section/record editors.
  # Hero and outro media fields accept an image OR a video path.
  FIELD_LABELS = {
    "heroImage"  => "Hero (image or video)",
    "heroVideo"  => "Hero Video (optional — plays instead of Hero)",
    "outroImage" => "Outro (image or video)",
    "outroVideo" => "Outro Video (optional — plays instead of Outro)"
  }.freeze

  def field_label(name)
    FIELD_LABELS[name.to_s] || name
  end

  def live_path_for(key, record)
    base = LIVE_PATHS[key]
    return nil unless base && record.is_a?(Hash) && record["id"].present?
    "#{base}/#{record['id']}"
  end

  # Heuristic: does this field hold an image/video/media path?
  def media_field?(name)
    name.to_s.match?(/image|photo|video|src|icon|logo|bg\b|thumbnail|panorama/i)
  end

  # Field that holds audio-track language rows, rendered with a repeatable
  # upload editor instead of a raw JSON textarea.
  def audio_tracks_field?(name)
    name.to_s == "tracks"
  end

  # Array of flat objects (all scalar values) — rendered as repeatable
  # field-rows instead of a raw JSON textarea. Media-named fields inside
  # each row get the thumbnail + Browse picker.
  def object_list_field?(value)
    value.is_a?(Array) && value.any? &&
      value.all? do |v|
        v.is_a?(Hash) && v.values.all? { |x| x.nil? || x.is_a?(String) || x.is_a?(Numeric) || x == true || x == false }
      end
  end

  # Array of image/video path strings — rendered with a repeatable
  # thumbnail + Browse editor instead of a raw JSON textarea.
  def image_list_field?(name, value)
    return false unless value.is_a?(Array) && value.all? { |v| v.is_a?(String) }
    return true if media_field?(name)
    value.any? && value.all? { |v| v.match?(%r{\.(jpe?g|png|webp|gif|svg|avif|mp4|webm)(\?|\z)}i) || v.start_with?("/rails/") }
  end
end
