class Payment::DonationsController < PaymentsController
  def index
    authorize Payment::Donation
    @donations = Payment::Donation.includes(:user).page(params[:page] || 0).per(15)
  end

  def new
    authorize Payment::Donation
    @donation = Payment::Donation.new
  end

  def create
    authorize Payment::Donation
    @donation = Payment::Donation.new(payment_donation_params)

    respond_to do |format|
      if @donation.save
        format.html { render :thank_you, notice: 'Donation was successfully sent!' }
        format.json { render :donation_thank_you, status: :created, location: @donation }
      else
        format.html { render :donation }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end
  end

  def thank_you
    redirect_to new_payment_donation_path
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def payment_donation_params
    params.require(:payment_donation).permit(policy(@donation || Payment::Donation).permitted_attributes)
  end

end
