require 'spec_helper'

describe SessionsController do
  describe 'GET new' do
    it 'renders the :new template if unauthenticated user' do
      get :new
      expect(response).to render_template :new
    end
    it 'redirects to home if authenticated user' do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe 'POST create' do
    context "with valid credentials" do
      let(:alice) { Fabricate(:user) }

      it 'sets session[:user_id] to user_id if user authenticated' do
        post :create, params: { user: { email: alice.email, password: alice.password } }
        expect(session[:user_id]).to eq(alice.id)
      end
      it 'redirects to home if user is authenticated'
      it 'flashes notice if user is authenticated'
    end

    context "with invalid credentials" do
      it 'flashes error if user cannot be authenticated'
      it 'redirects to sign_in if cannot be authenticated'
    end
  end

  describe 'POST destroy' do
    it 'sets session[:user_id] to nil'
    it 'redirects to root_path'
    it 'flashes notice of signout'
  end
end
