require 'json'

class APIv1 < Grape::API
  version 'v1', using: :path
  #content_type :json, "text/javascript"
  format :json
  #formatter :json, Grape::Formatter::RablRails.new(views: "#{Rails.root}/app/views/api")

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

    #get '' do
      #def uploads
        #@uploads ||= current_user.uploads
        #UploadDecorator.decorate_collection(@uploads)
      #end

      #JSON.parse ::RablRails.render(uploads, 'uploads/index')
    #end

    desc 'New upload'
    params do
      requires :file, type: Rack::Multipart::UploadedFile
    end
    post :file do
      file = ActionDispatch::Http::UploadedFile.new(params[:file])
      @upload = Upload.new(user: current_user)
      @upload.type = 'Upload::File'
      @upload.file = file
      if @upload.save
        {status: 'OK', url: UploadDecorator.decorate(@upload).url}
      else
        error! @upload.errors
      end
    end
  end
end
