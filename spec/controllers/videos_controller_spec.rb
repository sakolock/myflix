require 'spec_helper'

describe VideosController do
  describe 'GET show' do
    it 'sets @video for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, params: { id: video.id }
      expect(assigns(:video)).to eq(video)
    end

    it 'redirects to the sign in page for unauthenticated users' do
      video = Fabricate(:video)
      get :show, params: { id: video.id }
      expect(response).to redirect_to sign_in_path
    end
  end

  describe 'GET search' do
    it 'sets @results for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      futurama = Fabricate(:video, title: 'Futurama')
      get :search, params: { search_term: 'rama' }
      expect(assigns(:results)).to eq([futurama])
    end
    it 'redirects to sign_in page for unauthenticated users' do
      futurama = Fabricate(:video, title: 'Futurama')
      get :search, params: { search_term: 'rama' }
      expect(response).to redirect_to sign_in_path
    end
  end
end