class MissionsController < ApplicationController
  skip_before_action :redirect_to_new_session_path, only: :show
  before_action(only: :show) { redirect_to_new_session_path unless public? || session_exists? }
  before_action :set_mission, only: [:show, :edit, :update, :destroy, :reorder, :compute]
  before_action :set_scope, only: :index
  before_action :redirect_to_public_path_in_pdf_format, only: :show, if: :public_and_not_pdf_format_or_not_public_and_pdf_format?

  def index
    @missions = Mission.send @scope
  end

  def show
    not_found and return unless @mission.present?

    respond_to do |format|
      format.pdf { I18n.locale = :fr }
      format.html
    end
  end

  def edit

  end

  def new
    @mission = Mission.new user: @session.user
  end

  def update
    if @mission.update mission_params
      success :mission_saved
    else
      error :could_not_save_mission
    end

    if params.key? :show
      redirect_to mission_path(@mission)
    else
      render :edit
    end
  end

  def create
    @mission = Mission.new mission_params
    @mission.user = @session.user

    if @mission.save
      success :mission_created
      redirect_to mission_path(@mission)
    else
      error :could_not_create_mission
      render :new
    end
  end

  def destroy
    if @mission.destroy
      info :mission_deleted
      redirect_to missions_path
    else
      error :could_not_delete_mission
      redirect_to mission_path(@mission)
    end
  end

  def compute
    id = mission_params[:tasks_attributes].first[:id].to_i
    @mission.assign_attributes mission_params
    @task = @mission.tasks.to_a.find{ |task| task.id.to_i == id } || @mission.tasks.null
  end

  def reorder_tasks
    positions = mission_reorder_tasks_params[:tasks].map{ |task| [task[:id], task[:position]] }.to_h

    @mission.tasks.each { |task| task.position = positions[task.id] }

    if @mission.save
      head :no_content
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  protected

  def set_mission
    @mission = public? ? Mission.find_by(uuid: params[:uuid]) : Mission.find(params[:id])
  end

  def set_scope
    @scope = (params[:scope].presence || 'all').underscore
  end

  def mission_params
    params.require(:mission).permit(
      :name,
      :beginning_date,
      :ending_date,
      :referential_id,
      :referent_id,
      :project_id,
      :notes,
      referential_attributes: [
        :id,
        :man_day_duration,
        :work_per_day_duration
      ],
      tasks_attributes: [
        :id,
        :name,
        :pricing_id,
        :difficulty,
        :minimum_duration,
        :maximum_duration
      ]
    )
  end

  def mission_reorder_tasks_params
    params.require(:mission).permit tasks: [:id, :position]
  end

  def public?
    params.key? :uuid
  end

  def public_and_not_pdf_format_or_not_public_and_pdf_format?
    (public? && !request.format.pdf?) || (!public? && request.format.pdf?)
  end

  def redirect_to_public_path_in_pdf_format
    redirect_to public_mission_path(uuid: @mission.uuid, format: :pdf)
  end
end
