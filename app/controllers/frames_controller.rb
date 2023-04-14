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


  def connect #self as parent
    #frame must exits
    @frame = Frame.find_by(id: params[:frame][:child_id])
    ConnectedFrame.create(parent_id: params[:id], child_id: @frame.id)
    redirect_to @frame
  end

  def connect_new 
    # existing frame
    # link_new
    # we get a new blank frame
    parent_frame = Frame.find_by(id: params[:id])
    blank_name = "frame_#{param_hash.scene.frames.count + 1}"

    if @frame = Frame.create(name: blank_name, field_id: parent_frame.field_id)
      ConnectedFrame.create(parent_id: parent_frame.id, child_id: @frame.id)
      redirect_to @frame
    else
      @frame = parent_frame
      redirect_to @frame
    end
  end




  private 
  def frame_params
    params.require(:frame).permit(:name, :description, :goal, :danger, :obstacle, :field_id, :child_id)
  end

 

end