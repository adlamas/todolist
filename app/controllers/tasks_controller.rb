class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  include ActionView::RecordIdentifier

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.where(completed: false)
    @done_tasks = Task.where(completed: true)
    @task = Task.new
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  def active
    @task = Task.find(params[:id])
    @task.update(completed: !@task.completed) 
    respond_to do |format|
      #format.turbo_stream { render partial: 'tasks/active', locals: { task: @task } }
      @task.broadcast_render_later_to "tasks", partial: "tasks/active", locals: { task: @task }
    end
  end


  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_url, notice: "Task was successfully created." }
        @task.broadcast_render_to "tasks", partial: "tasks/create", locals: { task: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        @task.broadcast_render_to "tasks", partial: "tasks/create", locals: { errors: @task.errors }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
=begin
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_url(@task), notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end
=end

  def update
    @task.update(task_params)

    respond_to do |format|
      format.html         { redirect_to edit_task_url(@task)}
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('name_of_task', locals: { task: @task }, partial: 'tasks/task_name'),
          turbo_stream.replace('form_of_task', locals: { task: @task }, partial: 'tasks/form')
        ]
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  #def create_message
  #  @message = Message.new(params[:message])
  #  @message.broadcast_render_to "tasks", partial: "tasks/create_message", locals: { message: @message }
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:name, :completed)
    end
end
