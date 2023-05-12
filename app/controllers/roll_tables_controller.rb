class RollTablesController < ApplicationController
  include Generatable

  def new
    #check params to see of the table should be linked to a join table
    @roll_table = RollTable.new(roll_table_params)
    @roll_table.user_id = current_user.id
    render :new
  end

  def create
    @roll_table = RollTable.new(roll_table_params)
    @roll_table.user_id = current_user.id

    if @roll_table.save
      create_join_table!(@roll_table)
        # find link and create a joining appropriatly
         #link id table id, link_type

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

      values = create_completion("roll_table", prompt_str).except(:name)
        #values has a name key
        #roll_table model does not have a :name attribute which "generate" expects by defualt

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
    params.require(:roll_table).permit(:context, :row_count, :table_type, :column_count, :link_type, :link_id, completion: {} )
  end

  def row_data
    roll_table_params[:rows_attributes]["0"]
  end

  def create_join_table!(model) #params  #link_type link_id
    type = model.link_type
    join_table_class = LINKS[type]
    join_table_class.create!("#{type}_id" => model.link_id, "roll_table_id" => model.id)
  end

  LINKS =  {
      "quest" => QuestsRollTable, 
      #"villain" => FieldTable,
      #"settting" => FieldTable,
      #"objective" => FieldTable,
      "field" => FieldsRollTable
      #"creature"
    }
end