class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show edit update destroy ]

  def create
    byebug
    @message = Message.new(content: params[:content])
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  #def message_params
  #  params.require(:task).permit(:name, :completed)
  #end
end
