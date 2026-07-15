class MoveDarwazasIntoMonuments < ActiveRecord::Migration[8.1]
  # Darwazas belongs on the Monuments listing, not the Discover dropdown:
  # remove the dropdown entry (added by 20260715190000, which may already
  # have run on the deployed DB) and add a monuments card record instead.
  def up
    if (home = ContentBlock.find_by(key: "homePage"))
      data = home.data
      dropdown = data.dig("nav", "discoverDropdown")
      if dropdown.is_a?(Array) && dropdown.reject! { |i| i["url"] == "/darwazas" }
        home.update!(data: data)
      end
    end

    if (mons = ContentBlock.find_by(key: "monuments"))
      data = mons.data
      if data.is_a?(Array) && data.none? { |m| m["id"] == "darwazas" }
        seed_path = Rails.root.join("content.json")
        if File.exist?(seed_path)
          record = JSON.parse(File.read(seed_path))["monuments"].to_a.find { |m| m["id"] == "darwazas" }
          if record
            data << record
            mons.update!(data: data)
          end
        end
      end
    end
  end

  def down; end
end
