class TaxesController < ApplicationController
  before_action :set_tax, only: [:update, :destroy]
  before_action :set_mission, only: :index

  def index
    @taxes = @mission.present? ? @mission.taxes : Tax.settings
    @tax = Tax.new mission: @mission
  end

  def update
    if @tax.update tax_params
      success :tax_saved
    else
      error :could_not_save_tax
    end

    redirect_to @tax.mission.present? ? edit_mission_path(@tax.mission) : settings_path
  end

  def create
    @tax = Tax.new tax_params

    if @tax.save
      success :tax_created
    else
      error :could_not_create_tax
    end

    redirect_to @tax.mission.present? ? edit_mission_path(@tax.mission) : settings_path
  end

  def destroy
    if @tax.destroy
      info :tax_deleted
    else
      error :could_not_delete_tax
    end

    redirect_to @tax.mission.present? ? edit_mission_path(@tax.mission) : settings_path
  end

  private

  def set_tax
    @tax = Tax.find params[:id]
  end

  def set_mission
    @mission = Mission.find_by id: params[:mission_id]
  end

  def tax_params
    params.require(:tax).permit :name, :percentage, :mission_id
  end
end
