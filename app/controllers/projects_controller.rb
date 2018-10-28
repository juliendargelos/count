class ProjectsController < ApplicationController
  before_action :set_project, only: [:edit, :update, :destroy]

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def edit

  end

  def update
    if @project.update project_params
      success :project_saved
    else
      error :could_not_save_project
    end

    redirect_to projects_path
  end

  def create
    @project = Project.new project_params

    respond_to do |format|
      format.json do
        if @project.save
          render json: @project
        else
          render json: { error: @project.errors.full_messages.first }
        end
      end

      format.html do
        if @project.save
          success :project_created
        else
          error :could_not_create_project
        end

        redirect_to projects_path
      end
    end
  end

  def destroy
    if !@project.missions.count.zero?
      error 'This project still have missions, delete them before deleting the project'
    elsif @project.destroy
      info :project_deleted
    else
      error :could_not_delete_project
    end

    redirect_to projects_path
  end

  private

  def set_project
    @project = Project.find params[:id]
  end

  def project_params
    params.require(:project).permit :name, :notes, :company_id
  end
end
