require 'json'

class APIv1 < Grape::API
  version 'v1', using: :path
  format :json

  helpers do
    def logger
      API.logger
    end

    def current_user
      @current_user ||= User.where(api_key: params[:api_key]).first
      UserDecorator.decorate(@current_user) if @current_user
    end

    def authenticate!
      require_api_key!
      error!('401 Unauthorized', 401) unless current_user
    end

    def require_api_key!
      error!('401 api_key required', 401) unless params[:api_key]
    end

    def upload_params
      @upload_params ||= ActionController::Parameters.new(
        params.tap do |p|
          p[:file] = ActionDispatch::Http::UploadedFile.new(p[:file]) if p[:file]
        end
      ).permit(:file, :link, :code, :lang)
    end

    def upload_klass
      if upload_params.has_key? :file
        Upload::Blob
      elsif upload_params.has_key? :code
        Upload::Code
      elsif upload_params.has_key? :link
        Upload::Link
      else
        Upload
      end
    end
  end

  resource :account do
    before do
      authenticate!
    end

    desc 'Account status'
    get :status do
      JSON.parse(::RablRails.render current_user, 'users/show')
    end
  end

  resource :uploads do
    before do
      authenticate!
    end

    desc 'New upload'
    params do
      optional :file, type: Rack::Multipart::UploadedFile
      optional :link, type: String
      optional :code, type: String
      exactly_one_of :file, :link, :code
    end
    post '' do
      @upload = upload_klass.create(upload_params.merge(user: current_user))
      unless @upload.errors.any?
        status 201
        { url: UploadDecorator.decorate(@upload).url }
      else
        error! @upload.errors, 422
      end
    end
  end
end
