extends Node


# dictionary of identifier : modifiers[]
# identifiers: turn_start, turn_end, attack, skill, receive_attack, move
var parent_hero
var _modifier_map = {}


# Local modifiers (bool)
var can_move = true
var can_attack = true







func initialize(parent_class):
	parent_hero = parent_class
	initialize_modifier_map()


func initialize_modifier_map():
	_modifier_map["turn_start"] = []
	_modifier_map["turn_end"] = []
	_modifier_map["attack"] = []
	_modifier_map["skill"] = []
	_modifier_map["receive_attack"] = []
	_modifier_map["move"] = []

func add_modifier(modifier):
	modifier.initialize(parent_hero)
	
	for modifier_type in modifier._types:
		match modifier_type:
			"turn_start":
				_modifier_map.get("turn_start").append(modifier)
			
			"turn_end":
				_modifier_map.get("turn_end").append(modifier)
			
			"attack":
				_modifier_map.get("attack").append(modifier)
			
			"skill":
				_modifier_map.get("skill").append(modifier)
			
			"receive_attack":
				_modifier_map.get("receive_attack").append(modifier)
			
			"move":
				_modifier_map.get("move").append(modifier)


func on_turn_start():
	for modifier in _modifier_map.get("turn_start"):
		var remove = modifier.on_turn_start()

func on_turn_end():
	var modifiers_to_remove = []
	for modifier in _modifier_map.get("turn_end"):
		modifier.on_turn_end()
		if modifier.needs_to_be_removed:
			modifiers_to_remove.append(modifier)
	remove_modifiers(modifiers_to_remove)

func on_attack():
	pass

func on_skill():
	pass

func on_receive_attack():
	pass


func on_receive_skill(skill):
	#skill._damage_container._magical_damage -= 30
	pass


func on_move():
	pass



func remove_modifiers(modifier_list):
	var type_list
	var modifier_index
	if modifier_list.size() > 0:
		for modifier in modifier_list:
			for type in modifier._types:
				type_list = _modifier_map.get(type)
				modifier_index = type_list.find(modifier)
				type_list.remove(modifier_index)
				print("removed ", modifier)










