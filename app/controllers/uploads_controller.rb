class UploadsController < ApplicationController

  respond_to :html, :json
  inherit_resources

  helper_method :upload, :uploads

  before_action :authenticate_user!

  def index
    @upload = current_user.uploads
    gon.rabl template: "app/views/uploads/index.json.rabl", as: :uploads
    index!
  end

  def show
    if upload.secured?
      if params[:password]
        
      else
        render 'uploads/password_promt' and return
      end
    else
      send_data File.read(upload.file.path), filename: upload.file_file_name , type: upload.file_file_content_type, length: upload.file_file_size, disposition: 'upload'
    end
  end

  def create
    @upload = Upload.new()
    # params[:upload])
    @upload.user = current_user
    @upload.file = params[:upload][:file] if params[:upload][:file]
    create! do |format|
      format.json { render 'uploads/show' }
    end
  end

  def resource
    @upload ||= end_of_association_chain.find_by_sid!(params[:sid])
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
