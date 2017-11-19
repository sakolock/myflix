require 'spec_helper'

describe StripeWrapper do

  let(:valid_token) { "tok_visa" }
  let(:declined_card_token) { "tok_chargeDeclined" }

  describe StripeWrapper::Charge do
    describe '.create' do
      it 'makes a successful charge', :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          description: "a valid charge",
          source: valid_token
        )

        expect(response).to be_successful
      end

      it 'makes a card declined charge', :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          description: "a valid charge",
          source: declined_card_token
        )

        expect(response).not_to be_successful
      end

      it 'returns the error message for declined charges', :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          description: "a valid charge",
          source: declined_card_token
        )

        expect(response.error_message).to eq('Your card was declined.')
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      it "creates a customer with valid card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          source: valid_token
        )
        expect(response).to be_successful
      end

      it "returns the customer token for a valid card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          source: valid_token
        )
        expect(response.customer_token).to be_present
      end

      it "does not create a customer with a declined card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          source: declined_card_token
        )
        expect(response).not_to be_successful
      end

      it "returns the error message for a declined card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          source: declined_card_token
        )
        expect(response.error_message).to eq('Your card was declined.')
      end
    end
  end
end
