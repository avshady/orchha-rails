module Admin
  # Friendly editor for hash-type content blocks (homePage, historyPage,
  # settings, the *Page keys). Fields are derived recursively from the data's
  # own shape; anything too deep stays a validated JSON subfield.
  class SectionsController < BaseController
    before_action :set_block

    def edit
      unless @block.data.is_a?(Hash)
        redirect_to admin_collection_path(@block.key),
          alert: "#{@block.key} is a collection — use the record manager."
        return
      end
      @data = seed_merged(@block.key, @block.data)
    end

    def update
      submitted = params.fetch(:section, {}).to_unsafe_h
      @block.update!(data: apply_nested(seed_merged(@block.key, @block.data), submitted))
      redirect_to admin_root_path, notice: "#{@block.key} saved."
    rescue JSON::ParserError => e
      redirect_to admin_edit_section_path(@block.key),
        alert: "Invalid JSON in a structured field — nothing saved. #{e.message.truncate(120)}"
    end

    private

    def set_block
      @block = ContentBlock.find_by!(key: params[:key])
    end

    # The editor derives its fields from the data's shape, so a stale DB copy
    # hides keys added to content.json later (e.g. visit.bgImage on an old
    # deploy). Merge the seed underneath: seed keys show with DB values on top.
    def seed_merged(key, data)
      seed = JSON.parse(File.read(Rails.root.join("content.json")))[key]
      seed.is_a?(Hash) && data.is_a?(Hash) ? seed.deep_merge(data) : data
    rescue StandardError
      data
    end

    # Merges submitted form values into the existing structure, casting each
    # leaf back to the type it currently has. Keys absent from the form are
    # left untouched.
    def apply_nested(shape, submitted)
      return cast_leaf(shape, submitted) unless shape.is_a?(Hash) && submitted.is_a?(Hash)

      shape.merge(
        submitted.each_with_object({}) do |(key, value), out|
          out[key] = apply_nested(shape[key], value)
        end
      )
    end

    def cast_leaf(original, value)
      case original
      when TrueClass, FalseClass then value == "true"
      when Integer then Integer(value, exception: false) || Float(value, exception: false) || 0
      when Float, Numeric then Float(value, exception: false) || 0
      when Array, Hash then JSON.parse(value.to_s.presence || (original.is_a?(Array) ? "[]" : "{}"))
      else value.to_s
      end
    end
  end
end
