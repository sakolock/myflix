require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "valid personal info and valid card" do
      let(:customer) { double(:customer, successful?: true, customer_token: "abcdefg") }
      
      before do
        allow(StripeWrapper::Customer).to receive(:create).and_return(customer)
      end
      after { ActionMailer::Base.deliveries.clear }
      
      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(1)
      end

      it "stores the customer token from stripe" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.first.customer_token).to eq("abcdefg")
      end

      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com" )
        UserSignup.new(Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "John Doe")).sign_up("some_stripe_token", invitation.token)
        joe = User.where(email: "joe@example.com").first
        expect(joe.follows?(alice)).to be true
      end

      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com" )
        UserSignup.new(Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "John Doe")).sign_up("some_stripe_token", invitation.token)
        joe = User.where(email: "joe@example.com").first
        expect(alice.follows?(joe)).to be true
      end

      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com" )
        UserSignup.new(Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "John Doe")).sign_up("some_stripe_token", invitation.token)
        expect(Invitation.first.token).to be_nil
      end
  
      it 'sends out an email to the user with valid inputs' do
        UserSignup.new(Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "John Doe")).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end

      it 'sends out an email containing the user\'s name with valid inputs' do
        UserSignup.new(Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "John Doe")).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include('John Doe')
      end
    end

    context "with valid personal info and declined card" do
      it "does not create a new user record" do
        customer = double(:customer, successful?: false, error_message: 'Your card was declined.')
        allow(StripeWrapper::Customer).to receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up('1234123', nil)
        expect(User.count).to eq(0)
      end
    end

    context "with invalid personal info" do
      it "does not create user" do
        UserSignup.new(User.new(email: "my@example.com")).sign_up('1234123', nil)
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        expect(StripeWrapper::Customer).should_not_receive(:create)
        UserSignup.new(User.new(email: "my@example.com")).sign_up('1234123', nil)
      end

      it 'does not send out an email with invalid inputs' do
        UserSignup.new(User.new(email: "my@example.com")).sign_up('1234123', nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
