class HomeController < ApplicationController

  def index
    raw = ContentStore.raw
    @page = raw['homePage'] || {}
  rescue => e
    Rails.logger.error "CMS content read failed: #{e.message}"
    @page = {}
  end
end
