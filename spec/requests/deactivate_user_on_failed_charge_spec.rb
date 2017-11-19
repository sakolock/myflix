require 'spec_helper'

describe "Deactivate user on failed charge" do
  let(:event_data) do
    {
      "id" => "evt_1BPumEHHK4UD5LHyLhVNFFZl",
      "object" => "event",
      "api_version" => "2017-08-15",
      "created" => 1511105530,
      "data" => {
        "object" => {
          "id" => "ch_1BPumEHHK4UD5LHyrhRoE1Ah",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application" => nil,
          "application_fee" => nil,
          "balance_transaction" => nil,
          "captured" => false,
          "created" => 1511105530,
          "currency" => "usd",
          "customer" => "cus_BnMPkVJ78jhVTk",
          "description" => "",
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => "card_declined",
          "failure_message" => "Your card was declined.",
          "fraud_details" => {
          },
          "invoice" => nil,
          "livemode" => false,
          "metadata" => {
          },
          "on_behalf_of" => nil,
          "order" => nil,
          "outcome" => {
            "network_status" => "declined_by_network",
            "reason" => "generic_decline",
            "risk_level" => "normal",
            "seller_message" => "The bank did not return any further details with this decline.",
            "type" => "issuer_declined"
          },
          "paid" => false,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [
            ],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_1BPumEHHK4UD5LHyrhRoE1Ah/refunds"
          },
          "review" => nil,
          "shipping" => nil,
          "source" => {
            "id" => "card_1BPulLHHK4UD5LHy8QbIsXyu",
            "object" => "card",
            "address_city" => nil,
            "address_country" => nil,
            "address_line1" => nil,
            "address_line1_check" => nil,
            "address_line2" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_zip_check" => nil,
            "brand" => "Visa",
            "country" => "US",
            "customer" => "cus_BnMPkVJ78jhVTk",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 10,
            "exp_year" => 2022,
            "fingerprint" => "YN8x8lWq93jvEi0x",
            "funding" => "credit",
            "last4" => "0341",
            "metadata" => {
            },
            "name" => nil,
            "tokenization_method" => nil
          },
          "source_transfer" => nil,
          "statement_descriptor" => "Pmt to fail",
          "status" => "failed",
          "transfer_group" => nil
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => {
        "id" => "req_H4d62x8RC0pzQS",
        "idempotency_key" => nil
      },
      "type" => "charge.failed"
    }
  end

  it "deactivates the user with the web hook data from stripe for a charge failed", :vcr do
    alice = Fabricate(:user, customer_token: "cus_BnMPkVJ78jhVTk")
    post "/stripe_events", params: event_data
    expect(alice.reload).not_to be_active
  end
end
