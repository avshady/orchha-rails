module AdminHelper
  # Friendly names for content block keys.
  KEY_LABELS = {
    "homePage"          => "Home Page",
    "historyPage"       => "History Page",
    "monumentsPage"     => "Monuments Page Settings",
    "monuments"         => "Monuments",
    "experiencesPage"   => "Experiences Page Settings",
    "experienceItems"   => "Experiences & Trails",
    "cuisineItems"      => "Cuisine Items",
    "eventsPage"        => "Events Page Settings",
    "events"            => "Events",
    "accommodationPage" => "Accommodation Page Settings",
    "accommodations"    => "Hotels & Homestays",
    "supportUsPage"     => "Support Us Page Settings",
    "newsPage"          => "News Page Settings",
    "newsItems"         => "News",
    "museums"           => "Museums",
    "itineraries"       => "Itineraries",
    "freedomFighters"   => "Freedom Fighters",
    "hohoServices"      => "Hop-on Hop-off Services",
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
        { label: "Experiences", path: admin_collection_path("experienceItems"), match: %r{/(collections/(experienceItems|cuisineItems)|sections/experiencesPage)},
          children: [
            { label: "All Experiences", path: admin_collection_path("experienceItems"), match: %r{/collections/experienceItems} },
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
        { label: "Itineraries", path: admin_collection_path("itineraries"), match: %r{/collections/itineraries} },
        { label: "Freedom Fighters", path: admin_collection_path("freedomFighters"), match: %r{/collections/freedomFighters} },
        { label: "HOHO Services", path: admin_collection_path("hohoServices"), match: %r{/collections/hohoServices} },
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

  def live_path_for(key, record)
    base = LIVE_PATHS[key]
    return nil unless base && record.is_a?(Hash) && record["id"].present?
    "#{base}/#{record['id']}"
  end

  # Heuristic: does this field hold an image/video/media path?
  def media_field?(name)
    name.to_s.match?(/image|photo|video|src|icon|logo|bg\b|thumbnail|panorama/i)
  end
end
