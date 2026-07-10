module Admin
  class CollectionsController < BaseController
    def show
      @key = params[:key]
      block = ContentBlock.find_by!(key: @key)
      @records = block.data
      unless @records.is_a?(Array)
        redirect_to edit_admin_content_block_path(@key),
          alert: "#{@key} is not a collection — use the JSON editor."
      end
    end
  end
end
