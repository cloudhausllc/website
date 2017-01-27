class WebHook::StripeEventsController < ApplicationController
  before_action :set_web_hook_stripe_event, only: [:show, :edit, :update, :destroy]

  # GET /web_hook/stripe_events
  # GET /web_hook/stripe_events.json
  def index
    @web_hook_stripe_events = WebHook::StripeEvent.all
  end

  # GET /web_hook/stripe_events/1
  # GET /web_hook/stripe_events/1.json
  def show
  end

  # GET /web_hook/stripe_events/new
  def new
    @web_hook_stripe_event = WebHook::StripeEvent.new
  end

  # GET /web_hook/stripe_events/1/edit
  def edit
  end

  # POST /web_hook/stripe_events
  # POST /web_hook/stripe_events.json
  def create
    @web_hook_stripe_event = WebHook::StripeEvent.new(web_hook_stripe_event_params)

    respond_to do |format|
      if @web_hook_stripe_event.save
        format.html { redirect_to @web_hook_stripe_event, notice: 'Stripe event was successfully created.' }
        format.json { render :show, status: :created, location: @web_hook_stripe_event }
      else
        format.html { render :new }
        format.json { render json: @web_hook_stripe_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /web_hook/stripe_events/1
  # PATCH/PUT /web_hook/stripe_events/1.json
  def update
    respond_to do |format|
      if @web_hook_stripe_event.update(web_hook_stripe_event_params)
        format.html { redirect_to @web_hook_stripe_event, notice: 'Stripe event was successfully updated.' }
        format.json { render :show, status: :ok, location: @web_hook_stripe_event }
      else
        format.html { render :edit }
        format.json { render json: @web_hook_stripe_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /web_hook/stripe_events/1
  # DELETE /web_hook/stripe_events/1.json
  def destroy
    @web_hook_stripe_event.destroy
    respond_to do |format|
      format.html { redirect_to web_hook_stripe_events_url, notice: 'Stripe event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_web_hook_stripe_event
      @web_hook_stripe_event = WebHook::StripeEvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def web_hook_stripe_event_params
      params.require(:web_hook_stripe_event).permit(:livemode, :stripe_id, :object, :request, :api_version, :data)
    end
end
