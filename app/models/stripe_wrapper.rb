module StripeWrapper
  class Charge
    def self.create(options={})
      Stripe::Charge.create(
        :source    => options[:source],
        :amount      => options[:amount],
        :description => options[:description],
        :currency    => 'usd'
      )
    end
  end
end
