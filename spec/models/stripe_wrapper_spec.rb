require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe '.create' do
      it 'makes a successful charge', :vcr do
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']

        stripeToken = "tok_visa"

        response = StripeWrapper::Charge.create(
          amount: 999,
          description: "a valid charge",
          source: stripeToken
        )

        expect(response.amount).to eq(999)
        expect(response.currency).to eq('usd')
      end
    end
  end
end
