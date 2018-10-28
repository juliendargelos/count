class PricingsController < ApplicationController
  before_action :set_pricing, only: [:update, :destroy]
  before_action :set_mission, only: :index

  def index
    @pricings = @mission.present? ? @mission.pricings : Pricing.settings
    @pricing = Pricing.new mission: @mission
  end

  def update
    if @pricing.update pricing_params
      success :pricing_saved
    else
      error :could_not_save_pricing
    end

    redirect_to @pricing.mission.present? ? edit_mission_path(@pricing.mission) : settings_path
  end

  def create
    @pricing = Pricing.new pricing_params

    if @pricing.save
      success :pricing_created
    else
      error :could_not_create_pricing
    end

    redirect_to @pricing.mission.present? ? edit_mission_path(@pricing.mission) : settings_path
  end

  def destroy
    if @pricing.destroy
      info :pricing_deleted
    else
      error :could_not_delete_pricing
    end

    redirect_to @pricing.mission.present? ? edit_mission_path(@pricing.mission) : settings_path
  end

  private

  def set_pricing
    @pricing = Pricing.find params[:id]
  end

  def set_mission
    @mission = Mission.find_by id: params[:mission_id]
  end

  def pricing_params
    params.require(:pricing).permit :name, :man_day_price, :mission_id
  end
end
