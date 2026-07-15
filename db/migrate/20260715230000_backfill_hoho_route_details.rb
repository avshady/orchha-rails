class BackfillHohoRouteDetails < ActiveRecord::Migration[8.1]
  # The HOHO cards' expandable route section (Figma 3541-10147/10148) renders
  # only when a service record carries detailText/stops — fields added to the
  # seed after the deployed hohoServices row was created, so production never
  # received them and the dropdown never appeared. Copy the route fields from
  # content.json into any deployed record that still lacks them (matched by
  # id; admin-entered values are never overwritten).
  FIELDS = %w[detailText routeName routeSubtitle stops].freeze

  def up
    seed_path = Rails.root.join("content.json")
    return unless File.exist?(seed_path)

    seed = JSON.parse(File.read(seed_path))["hohoServices"].to_a
    block = ContentBlock.find_by(key: "hohoServices")
    return unless block && block.data.is_a?(Array)

    data = block.data
    data.each do |rec|
      next unless rec.is_a?(Hash)

      seed_rec = seed.find { |s| s.is_a?(Hash) && s["id"] == rec["id"] }
      next unless seed_rec

      # The old seed briefly shipped a 2-stop "Ram Raja Temple to the Ghats"
      # e-rickshaw route; the Figma design uses the 3-stop Full Orchha
      # Circuit. That exact old value is seed-provenance, not an admin edit.
      if rec["routeName"] == "Ram Raja Temple to the Ghats"
        rec["routeName"] = nil
        rec["stops"] = nil
      end

      FIELDS.each do |field|
        rec[field] = seed_rec[field] if rec[field].blank? && seed_rec[field].present?
      end
    end
    block.update!(data: data)
  end

  def down; end
end
