class TasksController < ApplicationController
  before_action :set_task, only: [:update, :destroy]

  def update
    if @task.update task_params
      success :task_saved
    else
      error :could_not_save_task
    end

    redirect_to mission_path(@task.mission)
  end

  def create
    @task = Task.new task_params

    if @task.save
      success :task_created
    else
      error :could_not_create_task
    end

    redirect_to mission_path(@task.mission)
  end

  def destroy
    if @task.destroy
      info :task_deleted
    else
      error :could_not_delete_task
    end

    redirect_to mission_path(@task.mission)
  end

  def compute
    @task = Task.new task_params
  end

  private

  def task_params
    params.require(:task).permit :name, :pricing_id, :difficulty, :minimum_duration, :maximum_duration, :mission_id
  end

  def set_task
    @task = Task.find params[:id]
  end
end
