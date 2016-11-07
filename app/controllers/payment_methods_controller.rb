class PaymentMethodsController < ApplicationController
  before_action :set_payment_method, only: [:destroy]

  # POST /payment_methods
  # POST /payment_methods.json
  def create
    authorize PaymentMethod.new(payment_method_params)
    @payment_method = PaymentMethod.new(payment_method_params)

    respond_to do |format|
      if @payment_method.save
        format.html { redirect_to edit_user_path(@payment_method.user), notice: 'Payment method was successfully created.' }
        format.json { render :show, status: :created, location: @payment_method }
      else
        flash[:danger] = 'There was an issue adding your new payment method. Please try again or e-mail info@cloudhaus.org for assistance.'
        format.html { redirect_to edit_user_path(@payment_method.user) }
        format.json { render json: @payment_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_methods/1
  # DELETE /payment_methods/1.json
  def destroy
    authorize @payment_method
    respond_to do |format|
      if @payment_method.destroy
        format.html { redirect_to edit_user_path(@payment_method.user), notice: 'Payment method was successfully destroyed.' }
        format.json { head :no_content }
      else
        flash[:danger] = 'There was an issue removing this payment method. Please try again or e-mail info@cloudhaus.org for assistance.'
        format.html { redirect_to edit_user_path(@payment_method.user) }
        format.json { render json: @payment_method.errors, status: :unprocessable_entity }
      end

    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_payment_method
    @payment_method = PaymentMethod.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def payment_method_params
    params.require(:payment_method).permit(policy(@payment_method || PaymentMethod).permitted_attributes)
  end
end
