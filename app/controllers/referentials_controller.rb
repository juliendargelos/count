class ReferentialsController < ApplicationController
  before_action :set_referential, only: [:update, :destroy]

  def index
    @referentials = Referential.settings
    @referential = Referential.new
  end

  def update
    if @referential.update referential_params
      success :referential_saved
    else
      error :could_not_save_referential
    end

    redirect_to settings_path
  end

  def create
    @referential = Referential.new referential_params

    if @referential.save
      success :referential_created
    else
      error :could_not_create_referential
    end

    redirect_to settings_path
  end

  def destroy
    if @referential.destroy
      info :referential_deleted
    else
      error :could_not_delete_referential
    end

    redirect_to settings_path
  end

  private

  def set_referential
    @referential = Referential.find params[:id]
  end

  def referential_params
    params.require(:referential).permit :man_day_duration, :work_per_day_duration
  end
end
