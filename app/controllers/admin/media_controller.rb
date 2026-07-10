module Admin
  # Media library: uploaded Active Storage blobs plus the site's bundled
  # /public/images files, browsable and selectable from any image field.
  class MediaController < BaseController
    def index
      @uploads = ActiveStorage::Blob.order(created_at: :desc)
      @site_images = site_image_paths

      respond_to do |format|
        format.html
        format.json do
          items = @uploads.map { |blob|
            { url: rails_storage_proxy_path(blob), name: blob.filename.to_s,
              kind: "upload", image: blob.content_type.to_s.start_with?("image/") }
          } + @site_images.map { |path|
            { url: path, name: File.basename(path), kind: "site", image: true }
          }
          render json: { items: items }
        end
      end
    end

    def create
      file = params.require(:file)
      blob = ActiveStorage::Blob.create_and_upload!(
        io: file.tempfile,
        filename: file.original_filename,
        content_type: file.content_type
      )
      render json: {
        url: rails_storage_proxy_path(blob), name: blob.filename.to_s,
        kind: "upload", image: blob.content_type.to_s.start_with?("image/")
      }, status: :created
    rescue ActionController::ParameterMissing
      render json: { error: "No file given." }, status: :unprocessable_entity
    end

    def destroy
      blob = ActiveStorage::Blob.find_signed!(params[:id])
      blob.purge
      redirect_to admin_media_path, notice: "File deleted."
    end

    private

    def site_image_paths
      Dir.glob(Rails.root.join("public/images/*.{jpg,jpeg,png,webp,gif,svg}"))
         .sort
         .map { |f| "/images/#{File.basename(f)}" }
    end
  end
end
