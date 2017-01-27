class WebHook::StripeEventsController < ApplicationController
  protect_from_forgery :except => :create
  before_action :convert_to_model, only: [:create]
  before_action :set_web_hook_stripe_event, only: [:show]

  # # GET /web_hook/stripe_events
  # # GET /web_hook/stripe_events.json
  def index
    authorize WebHook::StripeEvent
    @web_hook_stripe_events = WebHook::StripeEvent.all

  end

  # GET /web_hook/stripe_events/1
  # GET /web_hook/stripe_events/1.json
  def show
    authorize @web_hook_stripe_event
  end

  # POST /web_hook/stripe_events
  # POST /web_hook/stripe_events.json
  def create
    render :nothing => true, :status => 200, :content_type => 'text/html'
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
    rescue Stripe::InvalidRequestError => e
      @stripe_event = nil
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def web_hook_stripe_event_params
    params.require(:web_hook_stripe_event).permit(:livemode, :event_type, :stripe_id, :object, :request, :api_version, :data)
  end
end
