module Admin
  class UploadsController < BaseController
    # Accepts a multipart file, stores it via Active Storage, and returns a
    # permanent proxy URL that can be pasted into content fields.
    def create
      file = params.require(:file)
      blob = ActiveStorage::Blob.create_and_upload!(
        io: file.tempfile,
        filename: file.original_filename,
        content_type: file.content_type
      )
      render json: {
        url: rails_storage_proxy_path(blob),
        filename: blob.filename.to_s,
        byte_size: blob.byte_size
      }, status: :created
    rescue ActionController::ParameterMissing
      render json: { error: "No file given." }, status: :unprocessable_entity
    end
  end
end
