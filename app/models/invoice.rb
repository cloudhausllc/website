class Invoice < ActiveRecord::Base
  #TODO: Create and make this a subclass of StripeObject
  belongs_to :charge, foreign_key: :charge_id, primary_key: :stripe_id
  belongs_to :user, foreign_key: :customer_id, primary_key: :customer_id


  def self.create_from_stripe(json)
    json = convert_json_to_attributes(json)
    existing_check = Charge.where(stripe_id: json[:stripe_id])
    if existing_check.empty?
      Invoice.create(convert_json_to_attributes(json))
    else
      existing_check.first.update(json)
    end
  end

  def update_from_stripe(json)
    self.update(convert_json_to_attributes(json))
  end

  private

  def convert_json_to_attributes(json)
    Invoice.convert_json_to_attributes(json)
  end

  def self.convert_json_to_attributes(json)
    #TODO: Need to find a better way to do this...
    subscription_id = json['lines']['data'][0]['plan']['id'] || nil
    json = json.to_hash
    return {
        stripe_id: json['id'],
        subscription_id: subscription_id,
        charge_id: json['charge'],
        customer_id: json['customer'],
        amount_due: json['amount_due'],
        attempt_count: json['attempt_count'],
        attempted: json['attempted'],
        closed: json['closed'],
        date: json['date'],
        description: json['description'],
        livemode: json['livemode'],
        next_payment_attempt: json['next_payment_attempt'],
        period_start: json['period_start'],
        period_end: json['period_end'],
        subtotal: json['subtotal'],
        tax: json['tax'],
        tax_percent: json['tax_percent'],
        total: json['total'],
    }
  end


end
