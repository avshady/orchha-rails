class CustomPagesController < ApplicationController
  # Public renderer for admin-created pages; unknown or unpublished slugs 404.
  def show
    @page = Page.published.find_by!(slug: params[:slug])
    raw = ContentStore.raw
    @home = raw["homePage"] || {}
  end
end
