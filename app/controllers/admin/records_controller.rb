module Admin
  # CRUD for individual records inside an array-type content block.
  # Records are addressed by array index; every mutation rewrites the block.
  class RecordsController < BaseController
    before_action :load_collection

    def new
      # Blank template shaped like the first record so all fields show up.
      @record = @records.first.is_a?(Hash) ? blank_template(@records.first) : {}
      @index = nil
    end

    def create
      shape = @records.first.is_a?(Hash) ? @records.first : {}
      record = apply_fields(shape, {}, submitted_fields)
      @records << record
      save_collection
      live = helpers.live_path_for(@key, record)
      notice = if live
        "Record added — its page is live at <a href=\"#{live}\" target=\"_blank\">#{live}</a> and its card is on the listing page."
      else
        "Record added."
      end
      redirect_to admin_collection_path(@key), notice: notice
    rescue JSON::ParserError => e
      redirect_to admin_new_collection_record_path(@key),
        alert: "Invalid JSON in a structured field — nothing saved. #{e.message.truncate(120)}"
    end

    def edit
      @index = params[:index].to_i
      # Merge the content.json seed under the DB record so keys added to the
      # seed after a deploy (e.g. show* toggles, virtualTourUrl) surface in the
      # form even when this record's DB copy predates them. DB values win.
      @record = seed_merged_record(@records.fetch(@index))
    rescue IndexError
      redirect_to admin_collection_path(@key), alert: "Record not found."
    end

    def update
      index = params[:index].to_i
      existing = @records.fetch(index)
      # Cast submitted values against the seed-merged shape so newly-surfaced
      # keys (e.g. a boolean toggle absent from this DB record) get the right
      # type; preserve the existing record's other fields as the base.
      @records[index] = apply_fields(seed_merged_record(existing), existing, submitted_fields)
      save_collection
      redirect_to admin_collection_path(@key), notice: "Record updated."
    rescue JSON::ParserError => e
      redirect_to admin_edit_collection_record_path(@key, index),
        alert: "Invalid JSON in a structured field — nothing saved. #{e.message.truncate(120)}"
    rescue IndexError
      redirect_to admin_collection_path(@key), alert: "Record not found."
    end

    def destroy
      index = params[:index].to_i
      removed = @records.delete_at(index)
      save_collection if removed
      redirect_to admin_collection_path(@key), notice: removed ? "Record deleted." : "Record not found."
    end

    def move
      index = params[:index].to_i
      dir = params[:dir] == "up" ? -1 : 1
      target = index + dir
      if index.between?(0, @records.size - 1) && target.between?(0, @records.size - 1)
        @records[index], @records[target] = @records[target], @records[index]
        save_collection
      end
      redirect_to admin_collection_path(@key)
    end

    private

    def load_collection
      @key = params[:key]
      @block = ContentBlock.find_by!(key: @key)
      @records = @block.data
      unless @records.is_a?(Array)
        redirect_to edit_admin_content_block_path(@key), alert: "#{@key} is not a collection."
      end
    end

    def save_collection
      @block.update!(data: @records)
    end

    def submitted_fields
      params.fetch(:record, {}).to_unsafe_h
    end

    # Seed record from content.json matching this DB record (by id, else by
    # a same-shape sibling), merged underneath so the DB values take priority
    # but seed-only keys still appear. Returns the record unchanged on any
    # failure so editing never breaks.
    def seed_merged_record(db_record)
      return db_record unless db_record.is_a?(Hash)
      seed_list = seed_collection
      return db_record unless seed_list.is_a?(Array)
      seed_rec =
        if db_record["id"].present?
          seed_list.find { |r| r.is_a?(Hash) && r["id"] == db_record["id"] }
        end
      seed_rec ||= seed_list.find { |r| r.is_a?(Hash) }
      seed_rec.is_a?(Hash) ? seed_rec.merge(db_record) : db_record
    rescue StandardError
      db_record
    end

    def seed_collection
      @seed_collection ||= JSON.parse(File.read(Rails.root.join("content.json")))[@key]
    rescue StandardError
      nil
    end

    def blank_template(sample)
      sample.transform_values do |v|
        case v
        when String then ""
        when Numeric then 0
        when TrueClass, FalseClass then true
        when Array then []
        when Hash then {}
        end
      end
    end

    # Rebuilds a record from submitted params, casting each value back to the
    # type it has in `shape` (the existing record, or the collection's first
    # record for new ones). Fields absent from the form are preserved.
    def apply_fields(shape, base, submitted)
      record = base.dup
      submitted.each do |field, value|
        original = shape[field]
        record[field] =
          case original
          when TrueClass, FalseClass then value == "true"
          when Integer then value.to_s.strip.empty? ? 0 : Integer(value, exception: false) || Float(value, exception: false) || 0
          when Float, Numeric then value.to_s.strip.empty? ? 0 : Float(value, exception: false) || 0
          when Array, Hash then JSON.parse(value.presence || (original.is_a?(Array) ? "[]" : "{}"))
          else value.to_s
          end
      end
      record
    end
  end
end
