require 'spec_helper'

describe "Create payment on successful charge" do
  let(:event_data) do
    {
      "id" => "evt_1BPfCwHHK4UD5LHysUcBwZXN",
      "object" => "event",
      "api_version" => "2017-08-15",
      "created" => 1511045682,
      "data" => {
        "object" => {
          "id" => "ch_1BPfCvHHK4UD5LHyEUoq9dLW",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application" => nil,
          "application_fee" => nil,
          "balance_transaction" => "txn_1BPfCvHHK4UD5LHyXXXXxF9w",
          "captured" => true,
          "created" => 1511045681,
          "currency" => "usd",
          "customer" => "cus_BnFiWAnSCIzQJw",
          "description" => nil,
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => nil,
          "failure_message" => nil,
          "fraud_details" => {
          },
          "invoice" => "in_1BPfCvHHK4UD5LHygYAqYwQg",
          "livemode" => false,
          "metadata" => {
          },
          "on_behalf_of" => nil,
          "order" => nil,
          "outcome" => {
            "network_status" => "approved_by_network",
            "reason" => nil,
            "risk_level" => "normal",
            "seller_message" => "Payment complete.",
            "type" => "authorized"
          },
          "paid" => true,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [
            ],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_1BPfCvHHK4UD5LHyEUoq9dLW/refunds"
          },
          "review" => nil,
          "shipping" => nil,
          "source" => {
            "id" => "card_1BPfCtHHK4UD5LHyMa6naSo4",
            "object" => "card",
            "address_city" => nil,
            "address_country" => nil,
            "address_line1" => nil,
            "address_line1_check" => nil,
            "address_line2" => nil,
            "address_state" => nil,
            "address_zip" => "00112",
            "address_zip_check" => "pass",
            "brand" => "Visa",
            "country" => "US",
            "customer" => "cus_BnFiWAnSCIzQJw",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 3,
            "exp_year" => 2021,
            "fingerprint" => "0D7iHH5DsgRHcjaT",
            "funding" => "credit",
            "last4" => "4242",
            "metadata" => {
            },
            "name" => nil,
            "tokenization_method" => nil
          },
          "source_transfer" => nil,
          "statement_descriptor" => "MyFlix basic plan",
          "status" => "succeeded",
          "transfer_group" => nil
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => {
        "id" => "req_hmwdD1iPPFx60q",
        "idempotency_key" => nil
      },
      "type" => "charge.succeeded"
    }
  end
  
  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post "/stripe_events", params: event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_BnFiWAnSCIzQJw")
    post "/stripe_events", params: event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates the payment with the amount", :vcr do
    alice = Fabricate(:user, customer_token: "cus_BnFiWAnSCIzQJw")
    post "/stripe_events", params: event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with the reference id", :vcr do
    alice = Fabricate(:user, customer_token: "cus_BnFiWAnSCIzQJw")
    post "/stripe_events", params: event_data
    expect(Payment.first.reference_id).to eq("ch_1BPfCvHHK4UD5LHyEUoq9dLW")
  end
end
