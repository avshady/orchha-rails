class PagesController < ApplicationController
  CMS_CONTENT_PATH = Rails.root.join('content.json').freeze

  def history
    raw = JSON.parse(File.read(CMS_CONTENT_PATH))
    @page = raw['historyPage'] || {}
    @home = raw['homePage'] || {}
  rescue => e
    Rails.logger.error "CMS content.json read failed: #{e.message}"
    @page = {}
    @home = {}
  end

  def monuments
    raw = JSON.parse(File.read(CMS_CONTENT_PATH))
    @page = raw['monumentsPage'] || {}
    @monuments = (raw['monuments'] || []).select { |m| m['visible'] != false }
    @home = raw['homePage'] || {}
  rescue => e
    Rails.logger.error "CMS content.json read failed: #{e.message}"
    @page = {}
    @monuments = []
    @home = {}
  end

  def accommodation
    raw = JSON.parse(File.read(CMS_CONTENT_PATH))
    @page  = raw['accommodationPage'] || {}
    @items = raw['accommodations'] || []
    @home  = raw['homePage'] || {}
  rescue => e
    Rails.logger.error "CMS content.json read failed: #{e.message}"
    @page = {}; @items = []; @home = {}
  end

  def experiences
    raw = JSON.parse(File.read(CMS_CONTENT_PATH))
    @page     = raw['experiencesPage'] || {}
    @items    = raw['experienceItems'] || []
    @cuisine  = raw['cuisineItems'] || []
    @home     = raw['homePage'] || {}
  rescue => e
    Rails.logger.error "CMS content.json read failed: #{e.message}"
    @page = {}; @items = []; @cuisine = []; @home = {}
  end

  def experience_detail
    raw = JSON.parse(File.read(CMS_CONTENT_PATH))
    all = raw['experienceItems'] || []
    @exp  = all.find { |e| e['id'] == params[:id] }
    redirect_to '/experiences' and return unless @exp
    @home = raw['homePage'] || {}
  rescue => e
    Rails.logger.error "CMS content.json read failed: #{e.message}"
    redirect_to '/experiences'
  end

  def eco_trail
    raw = JSON.parse(File.read(CMS_CONTENT_PATH))
    @home = raw['homePage'] || {}
  rescue => e
    Rails.logger.error "CMS content.json read failed: #{e.message}"
    @home = {}
  end

  def monument
    raw = JSON.parse(File.read(CMS_CONTENT_PATH))
    all = raw['monuments'] || []
    @monument = all.find { |m| m['id'] == params[:id] }
    redirect_to '/monuments' and return unless @monument
    @home = raw['homePage'] || {}
    @all_monuments = all.select { |m| m['visible'] != false }
  rescue => e
    Rails.logger.error "CMS content.json read failed: #{e.message}"
    redirect_to '/monuments'
  end
end
