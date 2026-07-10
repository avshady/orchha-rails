class PagesController < ApplicationController

  def history
    raw = ContentStore.raw
    @page = raw['historyPage'] || {}
    @home = raw['homePage'] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}
    @home = {}
  end

  def monuments
    raw = ContentStore.raw
    @page = raw['monumentsPage'] || {}
    @monuments = (raw['monuments'] || []).select { |m| m['visible'] != false }
    @home = raw['homePage'] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}
    @monuments = []
    @home = {}
  end

  def accommodation
    raw = ContentStore.raw
    @page  = raw['accommodationPage'] || {}
    @items = raw['accommodations'] || []
    @home  = raw['homePage'] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}; @items = []; @home = {}
  end

  def events
    raw = ContentStore.raw
    @page  = raw['eventsPage'] || {}
    @items = (raw['events'] || []).select { |ev| ev['visible'] != false }
    @home  = raw['homePage'] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}; @items = []; @home = {}
  end

  def event
    raw = ContentStore.raw
    all = raw['events'] || []
    @event = all.find { |ev| ev['id'] == params[:id] }
    redirect_to '/events' and return unless @event
    @home = raw['homePage'] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    redirect_to '/events'
  end

  def sabhyata
    raw = ContentStore.raw
    @home = raw['homePage'] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @home = {}
  end

  def experiences
    raw = ContentStore.raw
    @page     = raw['experiencesPage'] || {}
    @items    = raw['experienceItems'] || []
    @cuisine  = raw['cuisineItems'] || []
    @home     = raw['homePage'] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}; @items = []; @cuisine = []; @home = {}
  end

  def experience_detail
    raw = ContentStore.raw
    all = raw['experienceItems'] || []
    @exp  = all.find { |e| e['id'] == params[:id] }
    redirect_to '/experiences' and return unless @exp
    @home = raw['homePage'] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    redirect_to '/experiences'
  end

  def eco_trail
    raw = ContentStore.raw
    @home = raw['homePage'] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @home = {}
  end

  def river_kayaking
    raw = ContentStore.raw
    all = raw['experienceItems'] || []
    @exp  = all.find { |e| e['id'] == 'river-kayaking' } || {}
    @home = raw['homePage'] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @exp = {}
    @home = {}
  end

  def monument
    raw = ContentStore.raw
    all = raw['monuments'] || []
    @monument = all.find { |m| m['id'] == params[:id] }
    redirect_to '/monuments' and return unless @monument
    @home = raw['homePage'] || {}
    @all_monuments = all.select { |m| m['visible'] != false }
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    redirect_to '/monuments'
  end
end
