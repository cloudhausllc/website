class Charge < ActiveRecord::Base
  #TODO: Create and make this a subclass of StripeObject
  belongs_to :user, foreign_key: :customer_id, primary_key: :stripe_customer_id
  belongs_to :invoice, foreign_key: :invoice_id, primary_key: :stripe_id
  belongs_to :payment_method, foreign_key: :source_id, primary_key: :stripe_card_id

  def self.create_from_stripe(json)
    json = convert_json_to_attributes(json)
    existing_check = Charge.where(stripe_id: json[:stripe_id])
    if existing_check.empty?
      Charge.create(convert_json_to_attributes(json))
    else
      existing_check.first.update(json)
    end
  end

  def update_from_stripe(json)
    self.update(convert_json_to_attributes(json))
  end

  private

  def convert_json_to_attributes(json)
    Charge.convert_json_to_attributes(json)
  end


  def self.convert_json_to_attributes(json)
    json = json.to_hash
    return {
        stripe_id: json['id'],
        invoice_id: json['invoice'],
        amount: json['amount'],
        amount_refunded: json['amount_refunded'],
        created: json['created'],
        customer_id: json['customer'],
        description: json['description'],
        dispute: json['dispute'],
        failure_code: json['failure_code'],
        failure_message: json['failure_message'],
        outcome: json['outcome'],
        status: json['status'],
        source_id: json['source']['id'],
    }
  end

end
