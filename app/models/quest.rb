class Quest < ApplicationRecord
  validates :villain, :location, :timer, :objective, presence: true

  def self.generate_quest
   Quest.new({ villain: Quest.get_villain, objective: Quest.get_objective, location: Quest.get_location, timer: Quest.get_timer})
  end

    def get_except(field)
      #@quest.attributes.except('villain', 'id', 'created_at', 'updated_at')
      fields = self.attributes.except(field, 'id', 'created_at', 'updated_at')
    
    end

   def clear!
    self.villain = 'empty'
    self.location = 'empty'
    self.objective = 'empty'
    self.timer = 'empty'
    self.save
   end


   private
    def self.get_villain
       'Princess,Necromancer,King,Butcher,Farmer,Demon,Fairy,Minotaur'.split(',').sample
    end


    
    def self.get_location
      part_1 = "castle,fort,fortress,village,town,dessert,hideout,camp,court,forest,jungle,wastes,
      peak,mountains,lodge,bunker,celler,sewers,bazaar,gravyard,tower,road,court,sea,island,field,asylum,
      prison,temple,church,mansion,mine,lab,study,carnival,circus,blackmarket,bog,kitchen,jail,trail,canyon,
      wagon train,ship,palace,convoy,morgue,hamlet,caves,caverns,keep,market,square".split(',').sample

      #factor this out into a seperate modifiers group
      part_2 = "secret,hidden,mysterious,murderous,haunted,drowned,sky,slave,trespassers,pilgrims,icy,submerged,
      interdeminsional,bloodsoaked,cloud,swamp,crumbling,ancient,overgrown,
      abandoned,accursed,otherworldy,barren,sleepy,watchful,frigid,crimson,merchant".split(',').sample
      part_2 + "-" + part_1
    end

    def self.get_timer
      timer = 'Volcano erupts,sun rises,sun sets,city gates close,reinforcements arrive,the location crumbles/sink/falls/or destroyed,court is adjourned,the invasion commences,the emissary arrives,the full moon wanes, the eclipse,the messenger arrives,the ship arrives,the caravan arrives,the coronation,the marriage ceremony,the ceremony,the ritual,the storm hits'.split(',').sample
      timer.capitalize
    end

    #OBJ
    #refactor this for general node building ie. villain,location etc
    #reroll modifiers? reroll objs?



    def self.get_objective
      type = ['people','places','things'].sample
      object = Quest.obj_options[type].sample.capitalize
      objective = Quest.modify_obj(type) + " the " + object
      objective
    end

    def self.obj_options
      #links to doc
      #the
      obj_list = { 
        #link to villains ?
        'people' => 'Princess,Necromancer,King,Butcher,Farmer,Demon,Fairy,Minotaur'.split(','),
        'places' => 'castle,fort,fortress,village,town,dessert,hideout,camp,court,forest,jungle,wastes,
      peak,mountains,lodge,bunker,celler,sewers,bazaar,gravyard,tower,road,court,sea,island,field,asylum,
      prison,temple,church,mansion,mine,lab,study,carnival,circus,blackmarket,bog,kitchen,jail,trail,canyon,
      wagon train,ship,palace,convoy,morgue,hamlet,caves,caverns,keep,market,square'.split(','),
        'things' => 'goblet,crown,blade,jewel,spear,trident,dagger,beast,chains,key,tapestry,cloak'.split(',')
      } #thing {modifer}  --> goblet + of + 'binding,searing,shadows etc' 
    end

     def self.modify_obj(type)
      case type
        when "things"
         modifier = "Steal,Hide,Seal away,destroy,forge".split(",").sample
        when "people"
          modifier ="escape,Seduce,Kidnap,Protect,Assasinate,investigate".split(",").sample
        when "places"
          modifier = "protect,escape,defend,seige,cleanse,desicrate,discover".split(",").sample
      end
      modifier.capitalize
    end
end
