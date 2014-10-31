class UploadsController < ApplicationController
  helper_method :upload, :uploads
  before_action :authenticate_user!, except: [:show, :download]

  def index
    collection_responder
  end

  def show
    @upload = Upload.find_by_sid!(params[:sid])
    resource_responder
  end

  def download
    @upload = Upload.find_by_sid!(params[:sid])
    validate_access
    upload.download!
    if upload.file?
      options = { x_sendfile: true, filename: upload.file_file_name, type: upload.file.content_type }
      if params[:raw]
        options.merge!(disposition: 'inline', type: upload.image? ? upload.content_type : 'text/plain')
      end
      send_file upload.file.path, options
      headers['Content-Length'] = upload.size.to_s
      return
    elsif upload.code?
      render text: upload.code
    end
  end

  def destroy
    @upload = current_user.uploads.find_by_sid!(params[:sid])
    respond_to do |format|
      format.json { render nothing: true, status: 204 }
    end
  end

  def create
    @upload = current_user.uploads.new(upload_params)
    if @upload.save
      resource_responder
    else
      error_responder
    end
  end

  protected

  def upload
    UploadDecorator.decorate resource
  end

  def uploads
    UploadDecorator.decorate_collection collection
  end

  private

  def collection
    @uploads ||= current_user.uploads.order(:id)
  end

  def resource
    @upload ||= current_user.uploads.find_by_sid!(params[:sid])
  end

  def collection_responder
    respond_to do |format|
      format.json
      format.html do
        gon.rabl template: 'app/views/uploads/index.rabl', as: :uploads
      end
    end
  end

  def resource_responder
    respond_to do |format|
      format.json { render 'uploads/show' }
      format.html do
        render 'uploads/show' and return if upload.secured?
        upload.download!
        redirect_to(upload.link) and return if upload.link?
      end
    end
  end

  def error_responder
    respond_to do |format|
      format.json do
        render(json: {errors: resource.errors.full_messages.to_json}, status: 422)
      end
    end
  end

  def validate_access
    if upload.secured? && !upload.validate_access(with_password: params[:password])
      flash[:error] = 'Bad password'
      redirect_to(action: :show) and return
    end
  end

  def upload_params
    params.require(:upload).permit(:encryption_type, :file, :link, :code, :lang)
  end
end
