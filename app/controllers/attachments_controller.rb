class AttachmentsController < ApplicationController

  respond_to :html, :json
  inherit_resources

  helper_method :attachment, :attachments

  def index
    @attachment = current_user.attachment
    gon.rabl template: "app/views/attachments/index.rabl", as: :attachments
    index!
  end

  def show
    if attachment.password_secured?
      if params[:password]
        
      else
        render 'attachments/password_promt' and return
      end
    else
      send_data File.read(attachment.file.path), filename: attachment.file_file_name , type: attachment.file_file_content_type, length: attachment.file_file_size, disposition: 'attachment'
    end
  end

  def create
    @attachment = Attachment.new()
    # params[:attachment])
    @attachment.user = current_user
    @attachment.file = params[:attachment][:file] if params[:attachment][:file]
    create! do |format|
      format.json { render 'attachments/show' }
    end
  end

  def resource
    @attachment ||= end_of_association_chain.find_by_sid!(params[:sid])
  end

  protected
    def attachment
      AttachmentDecorator.decorate resource
    end

    def attachments
      AttachmentDecorator.decorate_collection collection
    end

  private
    def permitted_params
      params.permit(attachment: [:type, :encryption_type, :file])
    end

end
