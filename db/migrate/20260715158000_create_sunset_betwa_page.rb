class CreateSunsetBetwaPage < ActiveRecord::Migration[8.1]
  # New standalone Sunset At Betwa page (hero + gallery carousel + "To Be
  # Self Explored" tag). Creates the content block on deployed databases,
  # since seeds only run on first boot. Audio guide / virtual tour tabs start
  # toggled off per the client's request for this page.
  DEFAULTS = {
    "showAudioGuide"  => false,
    "showVirtualTour" => false,
    "showTranslate"   => false,
    "virtualTourUrl"  => "",
    "heading"         => "Sunset At Betwa",
    "description"     => "The sunset at Orchha is not merely an event — it is a daily ceremony. As the light fades, the royal chhatris on the banks of the Betwa River are silhouetted against a sky ablaze with colour, their reflections trembling in the water.",
    "heroImage"       => "/images/exp_sunset_betwa.jpg",
    "galleryImages"   => [
      "/images/exp_sunset.jpg",
      "/images/rk_card_kayak_sunset.jpg",
      "/images/acc_mpt_betwa.jpg"
    ],
    "tagLabel"        => "To Be Self Explored"
  }.freeze

  def up
    return if ContentBlock.exists?(key: "sunsetBetwaPage")

    ContentBlock.create!(key: "sunsetBetwaPage", data: DEFAULTS)
  end

  def down; end
end
