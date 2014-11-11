require 'rails_helper'

RSpec.describe UploadsController, type: :controller do

  let(:json_response) { { format: 'json' } }
  let(:current_user) { create(:user) }

  before :each do
    allow(controller).to receive(:current_user).and_return(current_user)
    allow(controller).to receive(:authenticate_user!).and_return true
  end

  describe "GET index" do
    render_views

    it "assigns all uploads as @uploads" do
      upload = create(:link, user_id: current_user.id)
      get :index, json_response
      expect(assigns(:uploads)).to eq([upload])
    end
  end

  describe "GET show" do
    render_views

    it "assigns the requested upload as @upload" do
      upload = create(:link, user_id: current_user.id)
      get :show, json_response.merge(sid: upload.sid)
      expect(assigns(:upload)).to eq(upload)
    end
  end

  describe "POST create" do
    render_views

    describe "with valid params" do
      it "creates a new Upload" do
        expect {
          post :create, json_response.merge({upload: attributes_for(:link, user_id: current_user.id)})
        }.to change(Upload, :count).by(1)
      end

      it "assigns a newly created upload as @upload" do
        post :create, json_response.merge({upload: attributes_for(:link, user_id: current_user.id)})
        expect(assigns(:upload)).to be_a(Upload)
        expect(assigns(:upload)).to be_persisted
      end

      it "responds with newly created upload" do
        post :create, json_response.merge({upload: attributes_for(:link, user_id: current_user.id)})
        expect(assigns(:upload)).to eq(Upload.last)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested upload" do
      upload = create(:link, user_id: current_user.id)
      expect {
        delete :destroy, json_response.merge({sid: upload.sid})
      }.to change(Upload, :count).by(-1)
    end
  end
end
