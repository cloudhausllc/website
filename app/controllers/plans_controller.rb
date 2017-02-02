class PlansController < ApplicationController
  before_action :set_plan, only: [:destroy, :update]

  # GET /plans
  # GET /plans.json
  def index
    authorize Plan

    @plans = Plan.where(active: true)

    begin
      @stripe_plans = Stripe::Plan.all().to_hash
    rescue => e
      @stripe_plans = nil
    end
    # @stripe_plans[:data][0][:id]
    if not @stripe_plans.nil?
      @plans.each do |n|
        @stripe_plans[:data].delete_if { |i| i[:id] == n.stripe_plan_id }
      end
    end

    @new_plan = Plan.new(active: true)
  end

  # POST /plans
  # POST /plans.json
  def create
    @plan = Plan.new(plan_params)
    authorize @plan
    respond_to do |format|
      if @plan.save
        format.html { redirect_to plans_path, notice: 'Plan was successfully activated.' }
        format.json { render :index, status: :created }
      else
        #TODO: Display the actual error to the end user.
        flash[:danger] = 'There was an issue activating this plan.'
        format.html { redirect_to plans_path }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plans/1
  # PATCH/PUT /plans/1.json
  def update
    authorize @plan
    respond_to do |format|
      if @plan.update(permitted_attributes(@plan))
        format.html { redirect_to plans_path, notice: 'Plan was successfully updated.' }
        format.json { render :show, status: :ok, location: @plan }
      else
        format.html { render :edit }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy
    authorize @plan
    respond_to do |format|
      if @plan.update_attributes(active: false)
        format.html { redirect_to plans_url, notice: 'Plan was successfully deactivated.' }
        format.json { head :no_content }
      else
        flash[:danger] = 'There was an issue deactivating this plan.'
        format.html { redirect_to plans_url}
        format.json { render json: @plan.errors, status: :unprocessable_entity }

      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_plan
    @plan = Plan.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def plan_params
    params.require(:plan).permit(policy(@plan || Plan).permitted_attributes)
  end
end
