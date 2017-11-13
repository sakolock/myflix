require 'spec_helper'

describe UsersController do

  after { ActionMailer::Base.deliveries.clear }

  describe 'GET new' do
    it 'sets @user' do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe 'POST create' do
    context "with valid personal info and valid card" do

      let(:charge) { double(:charge, successful?: true) }
      before do
        allow(StripeWrapper::Charge).to receive(:create).and_return(charge)
        post :create, params:{ user: Fabricate.attributes_for(:user) }
      end

      it "creates the user" do
        expect(User.count).to eq(1)
      end

      it "redirects to sign in page" do
        expect(response).to redirect_to sign_in_path
      end

      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com" )
        post :create, params: { user: { email: "joe@example.com", password: "password", full_name: "John Doe" }, invitation_token: invitation.token }
        joe = User.where(email: "joe@example.com").first
        expect(joe.follows?(alice)).to be true
      end
      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com" )
        post :create, params: { user: { email: "joe@example.com", password: "password", full_name: "John Doe" }, invitation_token: invitation.token }
        joe = User.where(email: "joe@example.com").first
        expect(alice.follows?(joe)).to be true
      end
      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com" )
        post :create, params: { user: { email: "joe@example.com", password: "password", full_name: "John Doe" }, invitation_token: invitation.token }
        expect(Invitation.first.token).to be_nil
      end
    end

    context "with valid personal info and declined card" do
      it "renders the new template" do
        charge = double(:charge, successful?: false, error_message: 'Your card was declined.')
        allow(StripeWrapper::Charge).to receive(:create).and_return(charge)
        post :create, params:{ user: Fabricate.attributes_for(:user) }
        expect(response).to render_template :new
      end
      
      it "does not create a new user record" do
        charge = double(:charge, successful?: false, error_message: 'Your card was declined.')
        allow(StripeWrapper::Charge).to receive(:create).and_return(charge)
        post :create, params:{ user: Fabricate.attributes_for(:user) }
        expect(User.count).to eq(0)
      end

      it "sets the flash error message" do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        allow(StripeWrapper::Charge).to receive(:create).and_return(charge)
        post :create, params:{ user: Fabricate.attributes_for(:user) }
        expect(flash[:error]).to be_present
      end
    end

    context "with invalid personal info" do

      it "does not create user" do
        post :create, params: { user: { password: 'password', full_name: 'user name' } }
        expect(User.count).to eq(0)
      end

      it "renders the :new template" do
        post :create, params: { user: { password: 'password', full_name: 'user name' } }
        expect(response).to render_template :new
      end

      it "sets @user" do
        post :create, params: { user: { password: 'password', full_name: 'user name' } }
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "does not charge the card" do
        expect(StripeWrapper::Charge).should_not_receive(:create)
        post :create, params: { user: { password: 'password', full_name: 'user name' } }
      end
    end

    context "sending emails" do

      let(:charge) { double(:charge, successful?: true) }

      before do
        allow(StripeWrapper::Charge).to receive(:create).and_return(charge)
      end

      it 'sends out an email to the user with valid inputs' do
        post :create, params: { user: { email: "joe@example.com", password: "password", full_name: "Joe Smith" }}
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end

      it 'sends out an email containing the user\'s name with valid inputs' do
        post :create, params: { user: { email: "joe@example.com", password: "password", full_name: "Joe Smith" }}
        expect(ActionMailer::Base.deliveries.last.body).to include('Joe Smith')
      end

      it 'does not send out an email with invalid inputs' do
        post :create, params: { user: { email: "joe@example.com" }}
        expect(ActionMailer::Base.deliveries).to be_empty
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

  describe 'POST new_with_invitation_token' do
    it 'renders the :new view template' do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, params: { token: invitation.token }
      expect(response).to render_template :new
    end

    it 'sets @user with receipient\'s email address' do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, params: { token: invitation.token }
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it 'sets @invitation_token' do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, params: { token: invitation.token }
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it 'redirects to expired token page for invalid tokens' do
      get :new_with_invitation_token, params: { token: 'telsfasfs' }
      expect(response).to redirect_to expired_token_path
    end
  end
end
