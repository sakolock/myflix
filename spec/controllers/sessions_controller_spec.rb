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

    let(:alice) { Fabricate(:user) }

    context "with valid credentials" do

      before { post :create, params: { email: alice.email, password: alice.password } }
      
      it 'sets session[:user_id] to user_id if user authenticated' do
        expect(session[:user_id]).to eq(alice.id)
      end
      it 'redirects to home if user is authenticated' do
        expect(response).to redirect_to home_path        
      end
      it 'flashes notice if user is authenticated' do
        expect(flash[:notice]).not_to be_blank
      end
    end

    context "with invalid credentials" do
      
      before { post :create, params: { email: alice.email, password: alice.password + 'asfs' } }      
      
      it 'flashes error if user cannot be authenticated' do
        expect(flash[:error]).not_to be_blank
      end
      it 'redirects to sign_in if cannot be authenticated' do
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe 'POST destroy' do

    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end

    it 'sets session[:user_id] to nil' do
      expect(session[:user_id]).to be_nil
    end
    it 'redirects to sign_in_path' do
      expect(response).to redirect_to root_path
    end
    it 'flashes notice of signout' do
      expect(flash[:notice]).not_to be_blank
    end
  end
end
