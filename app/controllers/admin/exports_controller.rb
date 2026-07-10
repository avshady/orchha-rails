module Admin
  class ExportsController < BaseController
    # Full content backup, shaped exactly like content.json.
    def show
      send_data JSON.pretty_generate(ContentStore.raw),
        filename: "orchha-content-#{Time.current.strftime('%Y%m%d-%H%M')}.json",
        type: "application/json"
    end
  end
end
