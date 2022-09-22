class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show edit update destroy ]

  def index
    @messages = Message.all
  end

  def create
    @message = Message.new(content: params[:content])
    if @message.save!
      respond_to do |format|
        format.turbo_stream { render partial: 'messages/create', locals: { message: @message } }
      end
    end
  end

  def show
  end

  def new
    @message = Message.new
  end

  def edit
    respond_to do |format|
      format.html
      render view: 'messages/edit', locals: { message: @message }
    end
  end

  def update
    if @message.update!(content: message_params[:content])
      respond_to do |format|
        format.html { redirect_to tasks_url, notice: "Task was successfully updated." }
        format.turbo_stream { render partial: 'messages/update', locals: { message: @message } }
      end
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def message_params
    params.require(:message).permit(:content)
  end
end
