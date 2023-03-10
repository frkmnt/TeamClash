extends Node

var _overseer

var turn_queue = []

var party = []
#var enemies= []

func inititalize():
	_overseer = get_parent()
	var map_manager = _overseer._map_manager
	
	var hero = load_hero()
	map_manager.set_hero_on_tile(Vector2(0,0), hero)
	
	var hero2 = load_hero()
	map_manager.set_hero_on_tile(Vector2(5,0), hero2)
	
	inititalize_turn_queue()


func load_hero():
	var temp_hero = preload("res://Party/Heroes/Wizard/Wizard.tscn")
	var hero = temp_hero.instantiate()
	add_child(hero)
	party.append(hero)
	turn_queue.append(hero)
	hero.initialize(_overseer)
	return hero


func inititalize_turn_queue():
	pass




# Getters/Setters

func get_current_hero():
	return turn_queue[0]







func next_in_turn_queue():
	var current_hero = turn_queue.pop_front()
	turn_queue.append(current_hero)













