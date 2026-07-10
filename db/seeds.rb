# Imports content.json into content_blocks, one row per top-level key.
# Idempotent and non-destructive: existing rows (i.e. admin edits) are never
# overwritten — only missing keys are created.
path = Rails.root.join("content.json")

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
