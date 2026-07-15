class WordingSweepRamRajaAndReligiousWalk < ActiveRecord::Migration[8.1]
  # Data fix: deployed content_blocks predate the naming decisions
  # "Ram Raja Temple" (not Raja Ram) and "Religious Walk" (not Religious Trail),
  # and seeds never overwrite existing rows. Applies the renames to every
  # display string while leaving file paths and URLs untouched.
  REPLACEMENTS = {
    "Raja Ram Temple"  => "Ram Raja Temple",
    "Raja Ram Mandir"  => "Ram Raja Temple",
    "Religious Trail"  => "Religious Walk"
  }.freeze

  def up
    ContentBlock.find_each do |block|
      data = deep_replace(block.data)
      if data != block.data
        block.data = data
        block.save!
      end
    end
  end

  def down; end

  private

  def deep_replace(value)
    case value
    when Hash  then value.transform_values { |v| deep_replace(v) }
    when Array then value.map { |v| deep_replace(v) }
    when String
      return value if path_like?(value)
      REPLACEMENTS.reduce(value) { |s, (from, to)| s.gsub(from, to) }
    else value
    end
  end

  # File paths and URLs must keep their original spelling or assets 404.
  def path_like?(str)
    str.start_with?("/", "http", "Website Assets") || str.match?(/\.(jpe?g|png|webp|gif|svg|avif|mp4|webm|mp3)(\?|\z)/i)
  end
end
