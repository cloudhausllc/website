class PaymentsController < ApplicationController
  # GET /payments
  # GET /payments.json
  def index
    authorize Payment
    @payments = Payment.all.includes(:user).page(params[:page] || 0).per(15)
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def payment_donation_params
    params.require(:payment).permit(policy(Payment).permitted_attributes)
  end
end
