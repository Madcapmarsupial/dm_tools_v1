class FramesController < ApplicationController
  def index
    scene = Scene.find_by(id: params[:field_id])
    @frames = scene.frames
    render :index
  end

  def new
    @scene = Scene.find_by(id: params[:field_id])
    @frame = Frame.new(field_id: @scene.id)
    render :new
  end

  def create
      #frame_name = scene.frame_name
    @frame = Frame.new(frame_params)
      if @frame.save
        redirect_to @frame.scene 
      else
        @frame.errors.add :response, invalid_response: "#{response.errors.full_messages}"
        redirect_to @frame.scene, alert: @frame.errors.full_messages
      end
  end

  def show
    @frame = Frame.find_by(id: params[:id])
    render :show
  end

  def edit 
    @frame = Frame.find_by(id: params[:id])
    render :edit
  end

  def update
    @frame = Frame.find_by(id: params[:id])
    if @frame.update(frame_params)
      redirect_to @frame
    else
      redirect_to root_path, alert: @quest.errors.full_messages
    end
  end

  private 
  def frame_params
    params.require(:frame).permit(:name, :description, :goal, :danger, :obstacle, :field_id)
  end

 

end