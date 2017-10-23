require 'spec_helper'

describe PasswordResetsController do
  describe 'GET show' do
    it 'renders the show template if the token is valid' do
      alice = Fabricate(:user, token: '12345')
      get :show, params: { id: '12345' }
      expect(response).to render_template :show
    end

    it 'sets @token' do
      alice = Fabricate(:user, token: '12345')
      get :show, params: { id: '12345' }
      expect(assigns[:token]).to eq('12345')
    end

    it 'redirects to the expired token page if the token is not valid' do
      get :show, params: { id: '12345' }
      expect(response).to redirect_to expired_token_path
    end
  end

  describe 'POST create' do
    context 'with valid token' do
      it 'redirects the user to the sign in page' do
        alice = Fabricate(:user, password: 'old_password')
        alice.token = '12345'
        alice.save(:validate => false)
        post :create, params: { token: '12345', password: 'new_password'}
        expect(response).to redirect_to sign_in_path        
      end

      it 'updates the user\'s password' do
        alice = Fabricate(:user, password: 'old_password')
        alice.token = '12345'
        alice.save(:validate => false)
        post :create, params: { token: '12345', password: 'new_password'}
        expect(alice.reload.authenticate('new_password')).to be_truthy
      end
      
      it 'sets the flash success message' do
        alice = Fabricate(:user, password: 'old_password')
        alice.token = '12345'
        alice.save(:validate => false)
        post :create, params: { token: '12345', password: 'new_password'}
        expect(flash[:success]).to be_present
      end
      it 'sets the user\'s token to nil' do
        alice = Fabricate(:user, password: 'old_password')
        alice.token = '12345'
        alice.save(:validate => false)
        post :create, params: { token: '12345', password: 'new_password'}
        expect(alice.reload.token).to be_nil
      end
    end
    context 'with invalid token' do
      it 'redirects to the expired token path' do
        post :create, params: { token: '12345', password: 'new_password'}
        expect(response).to redirect_to expired_token_path        
      end
    end
  end
end
