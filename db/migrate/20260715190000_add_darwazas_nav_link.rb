class AddDarwazasNavLink < ActiveRecord::Migration[8.1]
  # The new Darwazas page gets a Discover dropdown entry. The darwazasPage
  # content block itself is a new key, so db:seed creates it on deploy;
  # only the existing homePage row needs this data fix.
  def up
    block = ContentBlock.find_by(key: "homePage")
    return unless block

    data = block.data
    dropdown = data.dig("nav", "discoverDropdown")
    return unless dropdown.is_a?(Array)
    return if dropdown.any? { |i| i["url"] == "/darwazas" }

    dropdown << { "label" => "Darwazas of Orchha", "url" => "/darwazas" }
    block.update!(data: data)
  end

  def down; end
end
