module Admin
  class ContentBlocksController < BaseController
    before_action :set_block

    def edit
      @json = JSON.pretty_generate(@block.data)
    end

    def update
      parsed = JSON.parse(params.require(:data))
      @block.update!(data: parsed)
      redirect_to admin_root_path, notice: "#{@block.key} saved."
    rescue JSON::ParserError => e
      @json = params[:data]
      flash.now[:alert] = "Invalid JSON — nothing saved. #{e.message.truncate(160)}"
      render :edit, status: :unprocessable_entity
    end

    private

    def set_block
      @block = ContentBlock.find_by!(key: params[:key])
    end
  end
end
