class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :get_edit_and_update_vars, only: [:edit, :update]

  # before_action :get_stripe_data, only: [:edit, :showd]

  # GET /users
  # GET /users.json
  def index
    authorize User
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  # def show
  #   authorize @user
  # end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    authorize @user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    # @new_payment_method = PaymentMethod.new

    respond_to do |format|
      if @user.save
        flash[:warning] = 'Your account has been created, but must be activated by an administrator.'
        format.html { redirect_to login_path }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    authorize @user
    respond_to do |format|
      if @user.update(permitted_attributes(@user))
        format.html { redirect_to edit_user_path(@user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    authorize @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(policy(@user || User).permitted_attributes)
  end

  def get_edit_and_update_vars
    @new_payment_method = PaymentMethod.new
    @plans = Plan.where(active: true)
  end
end
