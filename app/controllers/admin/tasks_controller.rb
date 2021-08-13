# frozen_string_literal: true

module Admin
  class TasksController < Admin::ApplicationController
    before_action :set_task, only: %i[show edit update destroy]

    def index
      @tasks = Task.all
    end

    def show
    end

    def new
      @task = Task.new
    end

    def edit
    end

    def create
      @task = Task.new(params[:task].permit!)

      if @task.save
        redirect_to(admin_tasks_path, notice: "Task was successfully created.")
      else
        render action: "new"
      end
    end

    def update
      if @task.update(params[:task].permit!)
        redirect_to(admin_tasks_path, notice: "Task was successfully updated.")
      else
        render action: "edit"
      end
    end

    def destroy
      @task.destroy
      redirect_to(admin_tasks_url)
    end

    private

    def set_task
      @task = Task.find(params[:id])
    end
  end
end
