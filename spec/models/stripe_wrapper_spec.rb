require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe '.create' do
      it 'makes a successful charge', :vcr do
        stripeToken = "tok_visa"
        response = StripeWrapper::Charge.create(
          amount: 999,
          description: "a valid charge",
          source: stripeToken
        )

        expect(response).to be_successful
      end

      it 'makes a card declined charge', :vcr do
        stripeToken = "tok_chargeDeclined"
        response = StripeWrapper::Charge.create(
          amount: 999,
          description: "a valid charge",
          source: stripeToken
        )

        expect(response).not_to be_successful
      end

      it 'returns the error message for declined charges', :vcr do
        stripeToken = "tok_chargeDeclined"
        response = StripeWrapper::Charge.create(
          amount: 999,
          description: "a valid charge",
          source: stripeToken
        )

        expect(response.error_message).to eq('Your card was declined.')
      end
    end
  end
end
