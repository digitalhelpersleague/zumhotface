class UploadsController < ApplicationController

  respond_to :html
  respond_to :json, except: :show
  inherit_resources

  custom_actions resource: [:download] 

  helper_method :upload, :uploads

  before_action :authenticate_user!, except: [:show, :download]

  def index
    gon.rabl template: "app/views/uploads/index.json.rabl", as: :uploads
    index!
  end

  def show
    @upload ||= end_of_association_chain.find_by_sid!(params[:sid])
    show! do |format|
      format.html do
        if !upload.secured?
          upload.download!
          redirect_to upload.link and return if upload.link?
        end
        render 'uploads/show'
      end
    end

  end

  def download
    @upload ||= end_of_association_chain.find_by_sid!(params[:sid])

    if upload.secured? and !upload.validate_access(with_password: params[:password])
      flash[:error] = "Bad password"
      redirect_to action: :show and return
    end

    upload.download!

    if upload.file?
      return send_file upload.file.path, x_sendfile: true, filename: upload.file_file_name, type: upload.file.content_type
    elsif upload.code?
      render text: upload.text and return
    end
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
      format.json {
        render json: {error: @upload.errors.messages.map{|k,v| "#{k} #{v.join(', ')}" }.join('; ')}, status: 403 and return if @upload.errors.any?
        render 'uploads/show'
      }
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
