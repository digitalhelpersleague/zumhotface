class UploadsController < ApplicationController

  respond_to :html, :json
  inherit_resources

  helper_method :upload, :uploads

  before_action :authenticate_user!

  def index
    #@uploads = current_user.uploads
    gon.rabl template: "app/views/uploads/index.json.rabl", as: :uploads
    index!
  end

  def show
    if upload.secured?
      if !params[:password].present?
        render 'uploads/password_promt' and return
      elsif upload.password != params[:password]
        render 'uploads/password_promt' and return
      end
    end
    upload.download!
    send_data File.read(upload.file.path), filename: upload.file_file_name , type: upload.file_content_type, length: upload.file_file_size, disposition: upload.disposition
  end

  def create
    @upload = Upload.new()
    # params[:upload])
    @upload.user = current_user
    if params[:upload][:file]
      @upload.type = 'Upload::File'
      @upload.file = params[:upload][:file] 
    end
    create! do |format|
      format.json { render 'uploads/show' }
    end
  end

  def destroy
    @upload = current_user.uploads.find_by_sid!(params[:sid])
    @upload.destroy
    destroy!
  end

  def collection
    @uploads ||= current_user.uploads.order(:id)
  end

  def resource
    @upload ||= current_user.uploads.find_by_sid!(params[:sid])
  end

  protected
    def upload
      UploadDecorator.decorate resource
    end

    def uploads
      UploadDecorator.decorate_collection collection
    end

  private
    def permitted_params
      params.permit(upload: [:type, :encryption_type, :file])
    end

end
