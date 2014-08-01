class GpgsController < ApplicationController

  respond_to :html, :json
  inherit_resources

  helper_method :gpg, :gpgs

  before_action :authenticate_user!

  def collection
    @gpgs ||= current_user.gpg_keys
  end

  def resource
    @gpg ||= current_user.gpg_keys.find_by_id!(params[:id])
  end

  protected
    def gpg
      GpgDecorator.decorate resource
    end

    def gpgs
      GpgDecorator.decorate_collection collection
    end

  private
    def permitted_params
      params.permit(gpg: [:encryption_type, :file, :files])
    end
end
