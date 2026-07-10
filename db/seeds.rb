# Imports content.json into content_blocks, one row per top-level key.
# Idempotent and non-destructive: existing rows (i.e. admin edits) are never
# overwritten — only missing keys are created.
path = Rails.root.join("content.json")

# Ensure the admin user exists (credentials from Railway env vars).
if ENV["ADMIN_EMAIL"].present? && ENV["ADMIN_PASSWORD"].present?
  user = User.find_or_initialize_by(email_address: ENV["ADMIN_EMAIL"])
  if user.new_record?
    user.password = ENV["ADMIN_PASSWORD"]
    user.save!
    puts "Created admin user #{user.email_address}."
  end
end

if File.exist?(path)
  data = JSON.parse(File.read(path, encoding: "UTF-8"))
  created = 0
  data.each do |key, value|
    next if ContentBlock.exists?(key: key)
    ContentBlock.create!(key: key, data: value)
    created += 1
  end
  puts "Seeded #{created} content block(s); #{ContentBlock.count} total."
else
  puts "content.json not found — skipping content seed."
end
