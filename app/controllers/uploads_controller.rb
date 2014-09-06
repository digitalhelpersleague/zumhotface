class UploadsController < ApplicationController
  respond_to :html
  respond_to :json, except: :show
  inherit_resources

  custom_actions resource: [:download]

  helper_method :upload, :uploads

  before_action :authenticate_user!, except: [:show, :download]

  def index
    @uploads ||= current_user.uploads.order('id DESC')
    gon.rabl template: 'app/views/uploads/index.json.rabl', as: :uploads
    index!
  end

  def show
    @upload ||= end_of_association_chain.find_by_sid!(params[:sid])
    show! do |format|
      format.html do
        unless upload.secured?
          upload.download!
          redirect_to(upload.link) && return if upload.link?
        end
        render 'uploads/show'
      end
    end
  end

  def download
    @upload ||= end_of_association_chain.find_by_sid!(params[:sid])

    if upload.secured? && !upload.validate_access(with_password: params[:password])
      flash[:error] = 'Bad password'
      redirect_to(action: :show) && return
    end

    upload.download!

    if upload.file?
      options = { x_sendfile: true, filename: upload.file_file_name, type: upload.file.content_type }
      options.merge!(disposition: 'inline', type: 'text/plain') if params[:raw]
      return send_file upload.file.path, options
    elsif upload.code?
      render(text: upload.code) && return
    end
  end

  def create
    @upload = Upload.new(user: current_user)
    if params[:upload][:file]
      @upload.file = params[:upload][:file]
    elsif params[:upload][:link]
      @upload.link = params[:upload][:link]
    elsif params[:upload][:code]
      @upload.code = params[:upload][:code]
      @upload.lang = params[:upload][:lang] if params[:upload][:lang]
    end
    create! do |format|
      format.json do
        render(json: { error: @upload.errors.messages.map { |k, v| "#{k} #{v.join(', ')}" }.join('; ') }, status: 403) && return if @upload.errors.any?
        render 'uploads/show'
      end
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
    params.permit(upload: [:encryption_type, :file, :link, :code, :lang])
  end
end
