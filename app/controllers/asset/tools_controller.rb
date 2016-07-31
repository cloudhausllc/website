class Asset::ToolsController < ApplicationController
  before_action :set_asset_tool, only: [:show, :edit, :update, :destroy]

  # GET /asset/tools
  # GET /asset/tools.json
  def index
    @asset_tools = Asset::Tool.all
  end

  # GET /asset/tools/1
  # GET /asset/tools/1.json
  def show
    authorize @asset_tool
  end

  # GET /asset/tools/new
  def new
    authorize Asset::Tool
    @asset_tool = Asset::Tool.new(user: User.current_user)
  end

  # GET /asset/tools/1/edit
  def edit
    authorize @asset_tool
  end

  # POST /asset/tools
  # POST /asset/tools.json
  def create
    authorize Asset::Tool
    @asset_tool = Asset::Tool.new(asset_tool_params)

    respond_to do |format|
      if @asset_tool.save
        format.html { redirect_to @asset_tool, notice: 'Tool was successfully created.' }
        format.json { render :show, status: :created, location: @asset_tool }
      else
        format.html { render :new }
        format.json { render json: @asset_tool.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /asset/tools/1
  # PATCH/PUT /asset/tools/1.json
  def update
    authorize @asset_tool
    respond_to do |format|
      if @asset_tool.update(asset_tool_params)
        format.html { redirect_to @asset_tool, notice: 'Tool was successfully updated.' }
        format.json { render :show, status: :ok, location: @asset_tool }
      else
        format.html { render :edit }
        format.json { render json: @asset_tool.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /asset/tools/1
  # DELETE /asset/tools/1.json
  def destroy
    authorize @asset_tool
    @asset_tool.destroy
    respond_to do |format|
      format.html { redirect_to asset_tools_url, notice: 'Tool was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asset_tool
      @asset_tool = Asset::Tool.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_tool_params
      params.require(:asset_tool).permit(policy(@asset_tool || Asset::Tool).permitted_attributes)
    end
end
