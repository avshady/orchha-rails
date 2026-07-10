# Single source of truth for CMS content.
#
# Content lives in content_blocks (one row per top-level content.json key) so
# admin edits persist across deploys. content.json remains as the seed source
# and as a read fallback when the table is missing or empty (e.g. first boot
# before db:seed, or asset-precompile-time boots without a database).
class ContentStore
  SOURCE_FILE = Rails.root.join("content.json").freeze

  class << self
    # Full content hash, shaped exactly like the parsed content.json.
    def raw
      blocks = ContentBlock.pluck(:key, :data).to_h
      blocks.empty? ? file_fallback : blocks
    rescue ActiveRecord::ActiveRecordError, ActiveRecord::NoDatabaseError
      file_fallback
    end

    def fetch(key)
      raw[key.to_s]
    end

    def write(key, value)
      block = ContentBlock.find_or_initialize_by(key: key.to_s)
      block.data = value
      block.save!
      block
    end

    def file_fallback
      JSON.parse(File.read(SOURCE_FILE, encoding: "UTF-8"))
    rescue => e
      Rails.logger.error "ContentStore: content.json fallback failed: #{e.message}"
      {}
    end
  end
end
