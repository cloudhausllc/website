class WebHook::StripeEventsController < ApplicationController
  protect_from_forgery :except => :create
  before_action :convert_to_model, only: [:create]
  before_action :set_web_hook_stripe_event, only: [:show]

  # # GET /web_hook/stripe_events
  # # GET /web_hook/stripe_events.json
  def index
    @web_hook_stripe_events = WebHook::StripeEvent.all
  end

  # GET /web_hook/stripe_events/1
  # GET /web_hook/stripe_events/1.json
  def show
  end

  # POST /web_hook/stripe_events
  # POST /web_hook/stripe_events.json
  def create
    # @stripe_event.save
    render :nothing => true, :status => 200, :content_type => 'text/html'

    # @web_hook_stripe_event = WebHook::StripeEvent.new(web_hook_stripe_event_params)
    #
    # respond_to do |format|
    #   if @web_hook_stripe_event.save
    #     format.html { redirect_to @web_hook_stripe_event, notice: 'Stripe event was successfully created.' }
    #     format.json { render :show, status: :created, location: @web_hook_stripe_event }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @web_hook_stripe_event.errors, status: :unprocessable_entity }
    #   end
    # end
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
