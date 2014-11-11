require 'linguist'

class UploadsController < ApplicationController
  respond_to :html, :json
  helper_method :upload, :uploads
  before_action :authenticate_user!, except: [:show, :download]

  def index
    respond_with uploads, gon: { rabl: { as: :uploads }}
  end

  def show
    @upload = Upload.find_by_sid!(params[:sid])
    respond_with upload, gon: { rabl: { as: :upload }}
  end

  def create
    @upload = current_user.uploads.create(upload_params)
    # reload class after create
    @upload = @upload.becomes @upload.type.constantize
    respond_with upload
  end

  def destroy
    if resource.destroy
      render nothing: true, status: 204
    else
      respond_with upload
    end
  end

  def download
    @upload = Upload.find_by_sid!(params[:sid])
    validate_access!
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

  protected

  def upload
    UploadDecorator.decorate resource
  end

  def uploads
    UploadDecorator.decorate_collection collection
  end

  private

  def collection
    @uploads ||= current_user.uploads.order(:id).reverse
  end

  def resource
    @upload ||= current_user.uploads.find_by_sid!(params[:sid])
  end

  def validate_access!
    if upload.secured? && !upload.validate_access(with_password: params[:password])
      flash[:error] = 'Bad password'
      redirect_to(action: :show) and return
    end
  end

  def upload_params
    params.require(:upload).permit(:file, :link, :code, :lang)
  end
end
