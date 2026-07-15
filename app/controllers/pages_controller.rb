class PagesController < ApplicationController
  def history
    raw = ContentStore.raw
    @page = raw["historyPage"] || {}
    @home = raw["homePage"] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}
    @home = {}
  end

  def monuments
    raw = ContentStore.raw
    @page = raw["monumentsPage"] || {}
    @monuments = (raw["monuments"] || []).select { |m| m["visible"] != false }
    @home = raw["homePage"] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}
    @monuments = []
    @home = {}
  end

  def freedom_fighters
    raw = ContentStore.raw
    @fighters = raw["freedomFighters"] || []
    @home = raw["homePage"] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @fighters = []
    @home = {}
  end

  def freedom_fighter
    raw = ContentStore.raw
    all = raw["freedomFighters"] || []
    @fighter = all.find { |f| f["id"] == params[:id] }
    redirect_to "/freedom-fighters" and return unless @fighter
    @home = raw["homePage"] || {}
    # Individual martyr pages are not part of the current mandate.
    @title = @fighter["name"]
    render "coming_soon"
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    redirect_to "/freedom-fighters"
  end

  def hoho
    raw = ContentStore.raw
    @services = raw["hohoServices"] || []
    @home = raw["homePage"] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @services = []
    @home = {}
  end

  def accommodation
    raw = ContentStore.raw
    @page  = raw["accommodationPage"] || {}
    @items = raw["accommodations"] || []
    @home  = raw["homePage"] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}; @items = []; @home = {}
  end

  def museums
    raw = ContentStore.raw
    @page  = raw["museumsPage"] || {}
    @items = (raw["museums"] || []).select { |m| m["visible"] != false }
    @home  = raw["homePage"] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}; @items = []; @home = {}
  end

  def art_frescoes
    raw = ContentStore.raw
    @page  = raw["artFrescoesPage"] || {}
    @items = raw["artFrescoes"] || []
    @home  = raw["homePage"] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}; @items = []; @home = {}
  end

  def news
    raw = ContentStore.raw
    @page  = raw["newsPage"] || {}
    @items = (raw["newsItems"] || []).select { |n| n["visible"] != false }
    @home  = raw["homePage"] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}; @items = []; @home = {}
  end

  def events
    raw = ContentStore.raw
    @page  = raw["eventsPage"] || {}
    @items = (raw["events"] || []).select { |ev| ev["visible"] != false }
    @home  = raw["homePage"] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}; @items = []; @home = {}
  end

  def event
    raw = ContentStore.raw
    all = raw["events"] || []
    @event = all.find { |ev| ev["id"] == params[:id] }
    redirect_to "/events" and return unless @event
    @home = raw["homePage"] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    redirect_to "/events"
  end

  def sabhyata
    raw = ContentStore.raw
    @page = raw["sabhyataPage"] || {}
    @home = raw["homePage"] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}
    @home = {}
  end

  def plan_your_visit
    raw = ContentStore.raw
    @page        = raw["planYourVisitPage"] || {}
    @itineraries = raw["itineraries"] || {}
    @home        = raw["homePage"] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}; @itineraries = {}; @home = {}
  end

  def visit_orchha
    raw = ContentStore.raw
    @page = raw["visitOrchhaPage"] || {}
    @home = raw["homePage"] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}
    @home = {}
  end

  def support_us
    raw = ContentStore.raw
    @page = raw["supportUsPage"] || {}
    @home = raw["homePage"] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}
    @home = {}
  end

  def experiences
    raw = ContentStore.raw
    @page     = raw["experiencesPage"] || {}
    @items    = raw["experienceItems"] || []
    @cuisine  = raw["cuisineItems"] || []
    @home     = raw["homePage"] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}; @items = []; @cuisine = []; @home = {}
  end

  def experience_detail
    raw = ContentStore.raw
    all = raw["experienceItems"] || []
    @exp  = all.find { |e| e["id"] == params[:id] }
    redirect_to "/experiences" and return unless @exp
    @home = raw["homePage"] || {}
    # This template holds the Art Walk content; experiences without their own
    # dedicated route (e.g. Night Walk) get a Coming Soon page instead.
    unless params[:id] == "art-walk"
      @title = @exp["name"]
      render "coming_soon" and return
    end
    @page = raw["artWalkPage"] || {}
    @audio_tracks = audio_tracks_for(raw, @exp["id"])
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    redirect_to "/experiences"
  end

  def sunset_betwa
    raw = ContentStore.raw
    @page = raw["sunsetBetwaPage"] || {}
    @home = raw["homePage"] || {}
    @audio_tracks = audio_tracks_for(raw, "sunset-betwa")
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}; @home = {}; @audio_tracks = []
  end

  def museum
    raw = ContentStore.raw
    all = raw["museums"] || []
    museum = all.find { |m| m["id"] == params[:id] }
    redirect_to "/museums" and return unless museum
    @home  = raw["homePage"] || {}
    @title = museum["name"]
    render "coming_soon"
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    redirect_to "/museums"
  end

  def eco_trail
    raw = ContentStore.raw
    @page = raw["ecoTrailPage"] || {}
    @home = raw["homePage"] || {}
    @audio_tracks = audio_tracks_for(raw, "eco-trail")
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @home = {}
  end

  def darwazas
    raw = ContentStore.raw
    @page = raw["darwazasPage"] || {}
    @home = raw["homePage"] || {}
    @audio_tracks = audio_tracks_for(raw, "darwazas")
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}; @home = {}; @audio_tracks = []
  end

  def river_kayaking
    raw = ContentStore.raw
    all = raw["experienceItems"] || []
    @exp  = all.find { |e| e["id"] == "river-kayaking" } || {}
    @page = raw["riverKayakingPage"] || {}
    @home = raw["homePage"] || {}
    @audio_tracks = audio_tracks_for(raw, "river-kayaking")
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @exp = {}
    @home = {}
  end

  def religious_walk
    raw = ContentStore.raw
    all = raw["experienceItems"] || []
    @exp  = all.find { |e| e["id"] == "religious-walk" } || {}
    @page = raw["religiousWalkPage"] || {}
    @home = raw["homePage"] || {}
    @audio_tracks = audio_tracks_for(raw, "religious-walk")
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @exp = {}
    @home = {}
  end

  def sound_light_show
    raw = ContentStore.raw
    @page = raw["soundLightShowPage"] || {}
    @home = raw["homePage"] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}
    @home = {}
  end

  def citadel_walk
    raw = ContentStore.raw
    @page = raw["citadelWalkPage"] || {}
    @home = raw["homePage"] || {}
    @audio_tracks = audio_tracks_for(raw, "citadel-walk")
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}
    @home = {}
  end

  def monument
    # Darwazas has a dedicated grouped-gates page; its listing card lives
    # with the monuments, so /monuments/darwazas forwards there.
    redirect_to "/darwazas" and return if params[:id] == "darwazas"

    raw = ContentStore.raw
    all = raw["monuments"] || []
    @monument = all.find { |m| m["id"] == params[:id] }
    redirect_to "/monuments" and return unless @monument
    @home = raw["homePage"] || {}
    @all_monuments = all.select { |m| m["visible"] != false }
    @audio_tracks = audio_tracks_for(raw, @monument["id"])
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    redirect_to "/monuments"
  end

  private

  # Language tracks for a page's audio guide, from the audioGuides collection.
  # Returns [] when no visible guide matches, so views fall back gracefully.
  def audio_tracks_for(raw, id)
    guide = (raw["audioGuides"] || []).find { |g| g["id"] == id && g["visible"] != false }
    tracks = guide && guide["tracks"]
    return [] unless tracks.is_a?(Array)
    tracks.select { |t| t.is_a?(Hash) && t["audio"].to_s.strip.present? }
  end
end
