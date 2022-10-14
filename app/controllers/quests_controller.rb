class QuestsController < ApplicationController
  def index
    @quests = Quest.all
  end

  def show
    #@quest = Quest.find(params[:id])
    villain = get_villain

    @quest = Quest.create({ villain: villain, objective: "The Lost Ark", location: "The Death Star", timer: "The World Ends"})
  end
  

  private
    def get_villain
       "bob,lewis,jerry".split(",").sample
    end


end
