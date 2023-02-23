# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   quests = Quest.create([{ villain: "Darth Vader", objective: "The Lost Ark", location: "The Death Star", timer: "The World Ends"}])
#   Character.create(name: "Luke", movie: movies.first)

Trait.all.destroy_all 
Field.all.destroy_all
Villain.all.destroy_all
EncounterResponse.all.destroy_all
Encounter.all.destroy_all
QuestResponse.all.destroy_all
Quest.all.destroy_all

q_prompt = <<~EOT
create a dnd scenario with a vampire as the villain, the setting is a swamp and the objective is a spellbook and limit the scenario to 4 encounters. your response should be in JSON format with 8 parameters ‘Scenario_name’, ’Description’, ‘Encounter_list’, ’Villain’, ’Setting’, ’Objective’, ‘Timer’, and ‘PlotTwist’. The 'Villain' parameter should hold 1 parameters 'name'. The 'Encounter_list' parameter should be a list of encounters. Each encounter should have only 1 parameter 'Encounter_name'. 
EOT

q_hash = {
"scenario_name": "The Vampire's Spellbook",
"description": "Deep in the heart of the swamp, a powerful vampire has been spotted wielding a powerful spellbook. The locals fear that the vampire is planning to use the book to raise an army of the undead and take over the nearby town. The players are tasked with finding and stealing the spellbook before it's too late.",
"encounter_list": [
{"encounter_name": "Swamp Ambush"},
{"encounter_name": "Vampire's Lair"},
{"encounter_name": "Spellbook Room"},
{"encounter_name": "Escape the Swamp"},
],
"villain": {
"name": "Count Draculor"
},
"setting": "A dense and foreboding swamp, shrouded in mist and danger",
"objective": "Find and steal the powerful spellbook before Count Draculor can use it to raise an army of the undead and take over the nearby town",
"timer": "The players have 24 hours before Count Draculor completes the ritual to raise the undead",
"plot_twist": "The spellbook is cursed, and anyone who tries to use it will be possessed by the spirit of the ancient vampire who wrote it, making them the new villain of the story."
}


e_hash = {
  "encounter_name": "Swamp Ambush",
  "description": "As the players enter the swamp, they are ambushed by a group of vampire thralls. The thralls have been lying in wait for any intruders, and they are hungry for fresh blood.",
  "location": "Deep in the heart of the swamp, surrounded by murky water and tangled vines.",
  "creatures": [
    {"name": "Vampire Thrall", "quantity": 4}
  ],
  "items": [],
  "consequences": "If the players defeat the vampire thralls, they will be able to proceed further into the swamp. If they fail, they will be captured and brought to the vampire's lair as prisoners.",
  "obstacles": "The murky water makes movement difficult, and the vines can be used as cover by the vampire thralls.",
  "magic": "The vampire thralls are able to move quickly and silently through the swamp, making it difficult for the players to track them.",
  "secrets": "If the players search the area thoroughly, they may find a hidden cache of weapons and supplies that will aid them in future encounters.",
  "lore": "The locals believe that the vampire has been living in the swamp for centuries, and that he is nearly invincible.",
  "active effects": []
}


e_prompt = <<~EOT
Q: #{q_prompt} 
A: #{q_hash}
Q: return the encounter named "Swamp Ambush" your response should be in JSON and have 11 parameters 'encounter_name', 'description', 'location', 'creatures', 'items', 'consequences', 'obstacles', 'magic', 'secrets', 'lore', and 'active effects'
EOT


q_text = {"id"=>"cmpl-6iZWIXxJhTI3QoDIIUibqjG3wu53M",
"object"=>"text_completion",
"created"=>1676080990,
"model"=>"text-davinci-003",
"choices"=>[{"text"=>q_hash.to_json, "index"=>0, "logprobs"=>nil, "finish_reason"=>"length"}],
"usage"=>{"prompt_tokens"=>100, "completion_tokens"=>300, "total_tokens"=>400}}.to_json

e_text =  {"id"=>"cmpl-6iZWIXxJhTI3QoDIIUibqjG3wu53d",
"object"=>"text_completion",
"created"=>1676080991,
"model"=>"text-davinci-003",
"choices"=>[{"text"=>e_hash.to_json, "index"=>0, "logprobs"=>nil, "finish_reason"=>"length"}],
"usage"=>{"prompt_tokens"=>700, "completion_tokens"=>800, "total_tokens"=>1500}}.to_json


q1 = Quest.create(staged_response: q_hash.to_json)
tester = QuestResponse.create( quest_id: q1.id, response_text: q_text, prompt: q_prompt)
e1 = Encounter.create(quest_id: q1.id, name: 'Swamp Ambush')
#q2 = Quest.create
EncounterResponse.create(full_response: e_text, encounter_id: e1.id, prompt: e_prompt)









#f1a =  Field.create(quest_id: q1.id, label: 'villain', value: 'witch')
# f1b =  Field.create(quest_id: q1.id, label: 'thing', value: 'goal')
# f1c =  Field.create(quest_id: q1.id, label: 'thing', value: 'timer')
# f1d =  Field.create(quest_id: q1.id, label: 'place', value: 'setting')

# f2a =  Field.create(quest_id: q2.id, label: 'person', value: 'villain')
# f2b =  Field.create(quest_id: q2.id, label: 'person', value: 'goal')
# f2c =  Field.create(quest_id: q2.id, label: 'thing', value: 'timer')
# f2d =  Field.create(quest_id: q2.id, label: 'place', value: 'setting')



# t1a =  Trait.create(field_id: f1a.id, label: 'who', note: 'blah')
# t1b =  Trait.create(field_id: f1b.id, label: 'name', value: 'wand')
# t1c =  Trait.create(field_id: f1c.id, label: 'fail consequence', value: 'volcano erupts')
# t1d =  Trait.create(field_id: f1d.id, label: 'name',  value: 'mountaintop')


# t2a =  Trait.create(field_id: f2a.id, label: 'who', value: 'moe', note: 'blah 2 blah 3')
# t2b =  Trait.create(field_id: f2b.id, label: 'name', value: 'princess')
# t2c =  Trait.create(field_id: f2c.id, label: 'fail consequence', value: 'princess dies')
# t2d =  Trait.create(field_id: f2d.id, label: 'name',  value: 'the royal court')
