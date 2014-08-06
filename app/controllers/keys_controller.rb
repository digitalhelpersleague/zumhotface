class KeysController < ApplicationController

  respond_to :html, :json
  inherit_resources

  helper_method :key, :keys

  before_action :authenticate_user!

  def index
    gon.rabl template: "app/views/keys/index.json.rabl", as: :keys
    index!
  end

  def collection
    @keys ||= current_user.keys
  end

  def resource
    @key ||= current_user.keys.find_by_id!(params[:id])
  end

  protected
    def key
      KeyDecorator.decorate resource
    end

    def keys
      KeyDecorator.decorate_collection collection
    end

  private
    def permitted_params
      params.permit(key: [:encryption_type, :file, :files])
    end
end
