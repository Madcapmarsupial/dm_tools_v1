class RollTablesController < ApplicationController
  include Generatable

  def new
    #check params to see of the table should be linked to a join table
    @roll_table = RollTable.new()

    render :new
  end

  def create
    @roll_table = RollTable.new(roll_table_params)
    @roll_table.user_id = current_user.id
    fail
    if @roll_table.save
      if params[:submit] == "generate" 
          params[:id] = @roll_table.id
            #add created obj's id to the params    
          generate
            #call to generate action
      else
          redirect_to roll_table_url(@roll_table.id)
        end
    else
      redirect_to root_path, alert: @roll_table.errors.full_messages
    end
  end

  def show
    @roll_table = RollTable.find_by(id: params[:id])
    @roll_table
  end

  def edit
    @roll_table = RollTable.find_by(id: params[:id])
    render :edit
  end

  def update 
    @roll_table = RollTable.find_by(id: params[:id])

    if @roll_table.update(roll_table_params)
      if params[:submit] == "generate"
        generate
      else
        redirect_to roll_table_url(@roll_table)
      end
    else
      redirect_to root_path, alert: @roll_table.errors.full_messages
    end
  end

  def generate
   @roll_table = RollTable.find_by(id: params[:id]) 
    begin  
      prompt_str = @roll_table.prompt(params)
      values = create_completion("roll_table", prompt_str)
      if @roll_table.update(values)
        redirect_to roll_table_url(@roll_table.id)
      else
        @roll_table.errors.add :response, invalid_response: "#{values.errors.full_messages}"
        redirect_to root_path, alert: @roll_table.errors.full_messages
      end
    rescue StandardError => e
      redirect_to root_path, alert: e
    end
  end

  private
  def roll_table_params
    params.require(:roll_table).permit(:row_count, :table_type, :column_list, completion: {})
  end
end