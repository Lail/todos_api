class Api::V1::TasksController < ApplicationController
  before_action :set_task, only: [:update, :destroy]

  # GET /tasks
  def index
    @tasks = Task.order(created_at: :desc).includes(:tags)

    render jsonapi: @tasks, include: :tags
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    if @task.save
      render jsonapi: @task, include: :tags, status: :created
    else
      render jsonapi_errors: @task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      render jsonapi: @task, include: :tags
    else
      render jsonapi_errors: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def task_params
      params.require(:data).require(:attributes).permit(:title, tags:[])
    end
end
