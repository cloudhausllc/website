class WebHook::StripeEventsController < ApplicationController
  protect_from_forgery :except => :create
  before_action :convert_to_model, only: [:create]
  before_action :set_web_hook_stripe_event, only: [:show]

  # # GET /web_hook/stripe_events
  # # GET /web_hook/stripe_events.json
  def index
    authorize WebHook::StripeEvent
    @web_hook_stripe_events = WebHook::StripeEvent.order(created_at: :desc).all.page(params[:page] || 0).per(15)

  end

  # GET /web_hook/stripe_events/1
  # GET /web_hook/stripe_events/1.json
  def show
    authorize @web_hook_stripe_event
  end

  # POST /web_hook/stripe_events
  # POST /web_hook/stripe_events.json
  def create
    begin
      #TODO: Instead of processing events here, why not move the processing code to appropriate models...
      if not @stripe_event.nil?
        # if @stripe_event.event_type == 'account.updated'
        # elsif @stripe_event.event_type == 'account.external_account.created'
        # elsif @stripe_event.event_type == 'account.external_account.deleted'
        # elsif @stripe_event.event_type == 'account.external_account.updated'
        # elsif @stripe_event.event_type == 'balance.available'
        # elsif @stripe_event.event_type == 'bitcoin.receiver.created'
        # elsif @stripe_event.event_type == 'bitcoin.receiver.filled'
        # elsif @stripe_event.event_type == 'bitcoin.receiver.updated'
        # elsif @stripe_event.event_type == 'bitcoin.receiver.transaction.created'
        # elsif @stripe_event.event_type == 'charge.captured'
        # elsif @stripe_event.event_type == 'charge.failed'
        # elsif @stripe_event.event_type == 'charge.pending'
        # elsif @stripe_event.event_type == 'charge.refunded'
        if @stripe_event.event_type == 'charge.succeeded'
          @stripe_event.mark_as_processing
          Charge.create_from_stripe(@stripe_event[:data])
          @stripe_event.mark_as_processed
          # elsif @stripe_event.event_type == 'charge.updated'
          # elsif @stripe_event.event_type == 'charge.dispute.closed'
          # elsif @stripe_event.event_type == 'charge.dispute.created'
          # elsif @stripe_event.event_type == 'charge.dispute.funds_reinstated'
          # elsif @stripe_event.event_type == 'charge.dispute.funds_withdrawn'
          # elsif @stripe_event.event_type == 'charge.dispute.updated'
          # elsif @stripe_event.event_type == 'coupon.created'
          # elsif @stripe_event.event_type == 'coupon.deleted'
          # elsif @stripe_event.event_type == 'coupon.updated'
        elsif @stripe_event.event_type == 'customer.created'
          @stripe_event.mark_as_processing
          user = User.find_by_email(@stripe_event[:data]['email'])
          if user.stripe_customer_id.nil? or user.stripe_customer_id != @stripe_event[:data]['id']
            user.stripe_customer_id = @stripe_event[:data]['id']
            user.save
          end
          @stripe_event.mark_as_processed

        elsif @stripe_event.event_type == 'customer.deleted'
          @stripe_event.mark_as_processing
          user = User.find_by_email(@stripe_event[:data]['email'])
          if not user.nil?
            [:stripe_customer_id, :stripe_subscription_id, :plan_id].each do |key|
              user.update_attribute(key, nil)
            end
            user.save(validate: false)
            user.payment_methods.delete_all
          end
          @stripe_event.mark_as_processed

        elsif @stripe_event.event_type == 'customer.updated'
          @stripe_event.mark_as_processing
          user = User.find_by_email(@stripe_event[:data]['email'])

          if user.stripe_customer_id.nil? or user.stripe_customer_id != @stripe_event[:data]['id']
            user.stripe_customer_id = @stripe_event[:data]['id']
            user.save
          end

          @stripe_event[:data]['sources']['data'].each do |card|
            current_card = user.payment_methods.where(stripe_card_id: card['id']).first_or_create
            [:brand, :exp_month, :exp_year, :last4].each do |key|
              current_card.update_attribute(key, card[key.to_s])
            end
          end


          @stripe_event.mark_as_processed
          # elsif @stripe_event.event_type == 'customer.bank_account.deleted'
          # elsif @stripe_event.event_type == 'customer.discount.created'
          # elsif @stripe_event.event_type == 'customer.discount.deleted'
          # elsif @stripe_event.event_type == 'customer.discount.updated'
        elsif @stripe_event.event_type == 'customer.source.created'
          @stripe_event.mark_as_processing
          user = User.find_by_stripe_customer_id(@stripe_event['data']['customer'])
          new_method = user.payment_methods.new(stripe_card_id: @stripe_event['data']['card'],
                                                brand: @stripe_event['data']['brand'],
                                                exp_month: @stripe_event['data']['exp_month'],
                                                exp_year: @stripe_event['data']['exp_year'],
                                                last4: @stripe_event['data']['last4'])
          new_method.save(validate: false)
          @stripe_event.mark_as_processed

        elsif @stripe_event.event_type == 'customer.source.deleted'
          @stripe_event.mark_as_processing
          PaymentMethod.find_by_stripe_card_id(@stripe_event['data']['id']).delete
          @stripe_event.mark_as_processed
          # elsif @stripe_event.event_type == 'customer.source.updated'
        elsif @stripe_event.event_type == 'customer.subscription.created'
          @stripe_event.mark_as_processing
          user = User.find_by_stripe_customer_id(@stripe_event['data']['customer'])
          plan = Plan.find_by_stripe_plan_id(@stripe_event['data']['plan']['id'])
          user.update_attribute(:plan_id, plan.id)
          @stripe_event.mark_as_processed
        elsif @stripe_event.event_type == 'customer.subscription.deleted'
          @stripe_event.mark_as_processing
          user = User.find_by_stripe_customer_id(@stripe_event['data']['customer'])
          user.update_attribute(:plan_id, nil)
          @stripe_event.mark_as_processed
          # elsif @stripe_event.event_type == 'customer.subscription.trial_will_end'
          #   #TODO: Eventually send the user an email. Right now we're not taking advantages of trials.
        elsif @stripe_event.event_type == 'customer.subscription.updated'
          @stripe_event.mark_as_processing
          user = User.find_by_stripe_customer_id(@stripe_event['data']['customer'])
          plan = Plan.find_by_stripe_plan_id(@stripe_event['data']['plan']['id'])
          user.update_attribute(:plan_id, plan.id)
          @stripe_event.mark_as_processed
        elsif @stripe_event.event_type == 'invoice.created'
          @stripe_event.mark_as_processing
          Invoice.create_from_stripe(@stripe_event['data'])
          @stripe_event.mark_as_processed
        elsif @stripe_event.event_type == 'invoice.payment_failed'
          @stripe_event.mark_as_processing
          Invoice.find_by_stripe_id(@stripe_event['data']['id']).update_from_stripe(@stripe_event['data'])
          @stripe_event.mark_as_processed
        elsif @stripe_event.event_type == 'invoice.payment_succeeded'
          @stripe_event.mark_as_processing
          Invoice.find_by_stripe_id(@stripe_event['data']['id']).update_from_stripe(@stripe_event['data'])
          @stripe_event.mark_as_processed
          # elsif @stripe_event.event_type == 'invoice.sent'
          #   @stripe_event.mark_as_processing
          #   Invoice.update_from_stripe(@stripe_event['data'])
          #   @stripe_event.mark_as_processed
          # elsif @stripe_event.event_type == 'invoice.updated'
          #   @stripe_event.mark_as_processing
          #   Invoice.update_from_stripe(@stripe_event['data'])
          #   @stripe_event.mark_as_processed
          # elsif @stripe_event.event_type == 'invoiceitem.created'
          # elsif @stripe_event.event_type == 'invoiceitem.deleted'
          # elsif @stripe_event.event_type == 'invoiceitem.updated'
          # elsif @stripe_event.event_type == 'order.created'
          # elsif @stripe_event.event_type == 'order.payment_failed'
          # elsif @stripe_event.event_type == 'order.payment_succeeded'
          # elsif @stripe_event.event_type == 'order.updated'
          # elsif @stripe_event.event_type == 'order_return.created'
          # elsif @stripe_event.event_type == 'plan.created'
        elsif @stripe_event.event_type == 'plan.deleted'
          @stripe_event.mark_as_processing
          Plan.find_by_stripe_plan_id(@stripe_event['data']['id']).update_attribute(:active, false)
          @stripe_event.mark_as_processed
        elsif @stripe_event.event_type == 'plan.updated'
          @stripe_event.mark_as_processing
          Plan.find_by_stripe_plan_id(@stripe_event['data']['id']).update_attributes(
              stripe_plan_amount: @stripe_event['data']['amount'],
              stripe_plan_interval: @stripe_event['data']['interval'],
              stripe_plan_trial_period_days: @stripe_event['data']['trial_period_days'],
              stripe_plan_name: @stripe_event['data']['name'],
          )
          @stripe_event.mark_as_processed
          # elsif @stripe_event.event_type == 'product.created'
          # elsif @stripe_event.event_type == 'product.deleted'
          # elsif @stripe_event.event_type == 'product.updated'
          # elsif @stripe_event.event_type == 'recipient.created'
          # elsif @stripe_event.event_type == 'recipient.deleted'
          # elsif @stripe_event.event_type == 'recipient.updated'
          # elsif @stripe_event.event_type == 'review.closed'
          # elsif @stripe_event.event_type == 'review.opened'
          # elsif @stripe_event.event_type == 'sku.created'
          # elsif @stripe_event.event_type == 'sku.deleted'
          # elsif @stripe_event.event_type == 'sku.updated'
          # elsif @stripe_event.event_type == 'source.canceled'
          # elsif @stripe_event.event_type == 'source.chargeable'
          # elsif @stripe_event.event_type == 'source.failed'
          # elsif @stripe_event.event_type == 'source.transaction.created'
          # elsif @stripe_event.event_type == 'transfer.created'
          # elsif @stripe_event.event_type == 'transfer.failed'
          # elsif @stripe_event.event_type == 'transfer.paid'
          # elsif @stripe_event.event_type == 'transfer.reversed'
          # elsif @stripe_event.event_type == 'transfer.updated'
        end
        render nothing: true, status: 200, content_type: 'text/html'
      else
        render nothing: true, status: 500, content_type: 'text/html'
      end
    rescue Exception => e
      render nothing: true, status: 500, content_type: 'text/html'
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_web_hook_stripe_event
    @web_hook_stripe_event = WebHook::StripeEvent.find(params[:id])
  end

  def convert_to_model
    begin
      event = Stripe::Event.retrieve(params['id'])
      @stripe_event = WebHook::StripeEvent.create({
                                                      livemode: event['livemode'],
                                                      stripe_id: event['id'],
                                                      event_type: event['type'],
                                                      object: event['object'],
                                                      request: event['request'],
                                                      api_version: event['api_version'],
                                                      data: event['data']['object'].to_json
                                                  })
    rescue Exception => e
      @stripe_event = nil
      raise e
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def web_hook_stripe_event_params
    params.require(:web_hook_stripe_event).permit(policy(@stripe_event || WebHook::StripeEvent).permitted_attributes)
  end


end
