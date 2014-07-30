class UploadsController < ApplicationController

  respond_to :html, :json
  inherit_resources

  helper_method :upload, :uploads

  before_action :authenticate_user!, except: [:show]

  def index
    gon.rabl template: "app/views/uploads/index.json.rabl", as: :uploads
    index!
  end

  def show
    @upload ||= end_of_association_chain.find_by_sid!(params[:sid])
    if upload.secured?
      if !params[:password].present?
        render 'uploads/password_promt' and return
      elsif upload.password != params[:password]
        render 'uploads/password_promt' and return
      end
    end
    upload.download!

    if upload.file?
      send_data File.read(upload.file.path), filename: upload.file.name , type: upload.file.content_type, length: upload.file.size, disposition: upload.disposition
    elsif upload.link?
      redirect_to upload.link and return
    elsif upload.code?
      render 'uploads/preview' and return
    end
    render 404
  end

  def create
    @upload = Upload.new(user: current_user)
    if params[:upload][:file]
      @upload.type = 'Upload::File'
      @upload.file = params[:upload][:file]
    end
    if params[:upload][:link]
      @upload.type = 'Upload::Link'
      @upload.link = params[:upload][:link]
    end
    if params[:upload][:code]
      @upload.type = 'Upload::Code'
      @upload.text = params[:upload][:code]
    end
    create! do |format|
      format.json { render 'uploads/show' }
    end
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
      params.permit(upload: [:encryption_type, :file, :files])
    end

end
