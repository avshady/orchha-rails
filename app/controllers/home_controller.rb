class HomeController < ApplicationController
  CMS_CONTENT_PATH = Rails.root.join('content.json').freeze

  def index
    raw = JSON.parse(File.read(CMS_CONTENT_PATH))
    @page = raw['homePage'] || {}
  rescue => e
    Rails.logger.error "CMS content.json read failed: #{e.message}"
    @page = {}
  end
end
