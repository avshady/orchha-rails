module Admin
  # Dedicated editor for the home page hero slideshow (images and videos).
  class HeroController < BaseController
    def edit
      home = ContentStore.fetch("homePage") || {}
      @slides = (home.dig("hero", "slides") || []).select { |s| s.is_a?(Hash) }
    end

    def update
      home = ContentStore.fetch("homePage") || {}
      slides = Array(params[:slides]).map { |s|
        src = s[:src].to_s.strip
        next if src.empty?
        { "type" => (s[:type] == "video" ? "video" : "image"), "src" => src }
      }.compact

      home["hero"] = (home["hero"] || {}).merge("slides" => slides)
      ContentStore.write("homePage", home)
      redirect_to admin_edit_hero_path,
        notice: "Hero saved — #{slides.size} slide(s) live on the <a href=\"/\" target=\"_blank\">home page</a>."
    end
  end
end
