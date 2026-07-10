module Admin
  class PagesController < BaseController
    before_action :set_page, only: [ :edit, :update, :destroy ]

    def index
      @pages = Page.order(:slug)
    end

    def new
      @page = Page.new
    end

    def create
      @page = Page.new(page_params)
      if @page.save
        redirect_to admin_pages_path, notice: "Page /#{@page.slug} created."
      else
        flash.now[:alert] = @page.errors.full_messages.to_sentence
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @page.update(page_params)
        redirect_to admin_pages_path, notice: "Page /#{@page.slug} saved."
      else
        flash.now[:alert] = @page.errors.full_messages.to_sentence
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @page.destroy
      redirect_to admin_pages_path, notice: "Page deleted."
    end

    private

    def set_page
      @page = Page.find(params[:id])
    end

    def page_params
      params.require(:page).permit(:slug, :title, :body, :published)
    end
  end
end
