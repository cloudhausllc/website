class IndexImagesController < ApplicationController
  before_action :set_index_image, only: [:show, :edit, :update, :destroy]

  # GET /index_images
  # GET /index_images.json
  def index
    authorize IndexImage
    @index_images = IndexImage.all
  end

  # GET /index_images/1
  # GET /index_images/1.json
  def show
    authorize @index_image
  end

  # GET /index_images/new
  def new
    authorize IndexImage
    @index_image = IndexImage.new
  end

  # GET /index_images/1/edit
  def edit
    authorize @index_image
  end

  # POST /index_images
  # POST /index_images.json
  def create
    authorize IndexImage
    @index_image = IndexImage.new(index_image_params)

    respond_to do |format|
      if @index_image.save
        format.html { redirect_to @index_image, notice: 'Index image was successfully created.' }
        format.json { render :show, status: :created, location: @index_image }
      else
        format.html { render :new }
        format.json { render json: @index_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /index_images/1
  # PATCH/PUT /index_images/1.json
  def update
    authorize @index_image
    respond_to do |format|
      if @index_image.update(index_image_params)
        format.html { redirect_to @index_image, notice: 'Index image was successfully updated.' }
        format.json { render :show, status: :ok, location: @index_image }
      else
        format.html { render :edit }
        format.json { render json: @index_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /index_images/1
  # DELETE /index_images/1.json
  def destroy
    authorize @index_image
    @index_image.destroy
    respond_to do |format|
      format.html { redirect_to index_images_url, notice: 'Index image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_index_image
      @index_image = IndexImage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def index_image_params
      params.require(:index_image).permit(policy(@index_image || IndexImage).permitted_attributes)
    end
end
