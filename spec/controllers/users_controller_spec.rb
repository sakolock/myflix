require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    it 'sets @user' do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe 'POST create' do
    context "with valid input" do

      before do
        post :create, params:{ user: Fabricate.attributes_for(:user) }
      end

      it "creates the user" do
        expect(User.count).to eq(1)
      end
      it "redirects to sign in page" do
        expect(response).to redirect_to sign_in_path
      end
    end
    context "with invalid input" do
      
      before do
        post :create, params: { user: { password: 'password', full_name: 'user name' } }
      end

      it "does not create user" do
        expect(User.count).to eq(0)
      end
      it "renders the :new template" do
        expect(response).to render_template :new
      end
      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end

  describe "GET show" do
    it_behaves_like "require sign in" do
      let(:action) { get :show, params: { id: 3 } }
    end

    it "sets @user" do
      set_current_user
      alice = Fabricate(:user)
      get :show, params: { id: alice.id }
      expect(assigns(:user)).to eq(alice)
    end
  end
end
