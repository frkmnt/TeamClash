extends Node2D


# ===Variables===

var _ui_manager
var _map_manager
var _party_manager

var _current_hero





# ===Bootstrap===



func _ready():
	inititalize_map()
	inititalize_party()
	inititalize_ui()
	start_turn()

func inititalize_map():
	_map_manager = $MapManager
	_map_manager.initialize()

func inititalize_party():
	_party_manager = $PartyManager
	_party_manager.inititalize()

func inititalize_ui():
	_ui_manager = $UIManager
	_ui_manager.inititalize()





# ===Turn Management===

func start_turn():
	_current_hero = _party_manager.get_current_hero()
	_current_hero.start_turn()
	_map_manager.highlight_current_hero_tile(_current_hero)
	_ui_manager.assign_current_hero_skills(_current_hero)

func end_turn():
	_party_manager.get_current_hero().end_turn()
	_map_manager.remove_highlight_from_confirm_tiles()
	_map_manager.remove_highlight_from_select_tiles()
	_map_manager.remove_current_hero_highlight()
	_party_manager.next_in_turn_queue()
	_ui_manager.clear_skill_list()





# ===Click Management===

var current_state = "neutral" # neutral, inspect, move, attack, skill, pass

func tile_was_clicked(coordinates):
	var clicked_tile = _map_manager.get_tile_with_coordinates(coordinates)
	
	match current_state:
		"neutral":
			pass # camera pan
		
		"inspect":
			var description = _map_manager.inspect_tile(coordinates)
			print(description)
		
		"move":
			on_click_move(clicked_tile)
		
		"attack":
			on_click_attack(clicked_tile)
		
		"skill":
			on_click_skill(clicked_tile)
		
		"pass":
			pass


func on_click_neutral():
	pass


func on_click_inspect():
	pass


func on_click_move(clicked_tile):
	if _map_manager._confirm_tiles.size() > 0:
		if clicked_tile in _map_manager._confirm_tiles:
			_map_manager.remove_highlight_from_confirm_tiles()
			_map_manager.remove_current_hero_highlight()
			_map_manager.remove_hero_from_tile(_current_hero._coordinates)
			
			_map_manager.move_hero_to_tile(clicked_tile, _current_hero)
			_map_manager.highlight_current_hero_tile(_current_hero)
			_current_hero.on_move()
			assign_current_hero_moveable_tiles()
		else:
			_map_manager.remove_highlight_from_confirm_tiles()
		
		_map_manager.highlight_tiles_select(_current_hero._moveable_tiles)
		_map_manager._confirm_tiles.clear()
	
	else:
		if clicked_tile in _current_hero._moveable_tiles \
		and clicked_tile != _map_manager.get_tile_with_coordinates(_current_hero._coordinates):
			_map_manager.remove_highlight_from_select_tiles()
			_map_manager.highlight_tile_confirm(clicked_tile)




func on_click_attack(clicked_tile):
	if _map_manager._confirm_tiles.size() > 0:
		if clicked_tile in _map_manager._confirm_tiles:
			clicked_tile._tile_hero.receive_attack(_current_hero.get_basic_attack())
		else:
			_map_manager.remove_highlight_from_confirm_tiles()
			_map_manager.highlight_tiles_select(_current_hero._attackable_tiles)
	
	else:
		if clicked_tile in _current_hero._attackable_tiles \
		and clicked_tile != _map_manager.get_tile_with_coordinates(_current_hero._coordinates):
			_map_manager.remove_highlight_from_select_tiles()
			_map_manager.highlight_tile_confirm(clicked_tile)




func on_click_skill(clicked_tile):
	_ui_manager.on_skill_click(clicked_tile)








func on_click_pass():
	pass










# ===Handle Button/State===


# Inspect
func inspect_button():
	if current_state == "inspect":
		remove_state_inspect()
		current_state = "neutral"
	else:
		remove_current_state()
		set_state_inspect()

func set_state_inspect():
	current_state = "inspect"
	pass

func remove_state_inspect():
	_ui_manager._inspect_button.pressed = false



# Move
func move_button():
	if current_state == "move":
		remove_state_move()
		current_state = "neutral"
	else:
		remove_current_state()
		set_state_move()

func set_state_move():
	current_state = "move"
	if _current_hero._calculate_moveable_tiles:
		assign_current_hero_moveable_tiles()
	_map_manager.highlight_tiles_select(_current_hero._moveable_tiles)

func remove_state_move():
	_ui_manager._move_button.pressed = false
	_map_manager.remove_highlight_from_confirm_tiles()
	_map_manager.remove_highlight_from_select_tiles()



# Attack
func attack_button():
	if current_state == "attack":
		remove_state_attack()
		current_state = "neutral"
	else:
		remove_current_state()
		set_state_attack()

func set_state_attack():
	current_state = "attack"
	if _current_hero._calculate_attackable_tiles:
		assign_current_hero_attackable_tiles()
		_current_hero._calculate_attackable_tiles = false
	_map_manager.highlight_tiles_select(_current_hero._attackable_tiles)

func remove_state_attack():
	_ui_manager._attack_button.pressed = false
	_map_manager.remove_highlight_from_confirm_tiles()
	_map_manager.remove_highlight_from_select_tiles()



#Skill
func skill_button():
	if current_state == "skill":
		remove_state_skill()
		current_state = "neutral"
	else:
		remove_current_state()
		set_state_skill()

func set_state_skill():
	current_state = "skill"
	_ui_manager.show_skill_menu()

func remove_state_skill():
	_ui_manager._skill_button.pressed = false
	_ui_manager.hide_skill_menu()
	_map_manager.remove_highlight_from_confirm_tiles()
	_map_manager.remove_highlight_from_select_tiles()



#Pass
func pass_button():
	if current_state != "pass":
		set_state_pass()

func set_state_pass():
	remove_current_state()
	current_state = "neutral"
	end_turn()
	start_turn()

func remove_state_pass():
	pass



func remove_current_state():
	match current_state:
		"move":
			remove_state_move()
		"attack":
			remove_state_attack()
		"skill":
			remove_state_skill()
		"inspect":
			remove_state_inspect()
		"pass":
			remove_state_pass()












# ===Utility Functions===

func assign_current_hero_moveable_tiles():
	_current_hero._moveable_tiles = \
	_map_manager.get_moveable_tiles( \
	_current_hero._coordinates, _current_hero._remaining_speed)
	
	_current_hero._moveable_tiles.remove( \
	_current_hero._moveable_tiles.find(\
	_map_manager.get_tile_with_coordinates(_current_hero._coordinates)))
	
	_current_hero._calculate_moveable_tiles = false



func assign_current_hero_attackable_tiles():
	_current_hero._attackable_tiles = \
	_map_manager.get_attackable_tiles_in_range( \
	_current_hero._coordinates, _current_hero._basic_attack._range)
	
	_current_hero._attackable_tiles.remove( \
	_current_hero._attackable_tiles.find(\
	_map_manager.get_tile_with_coordinates(_current_hero._coordinates)))
	
	_current_hero._calculate_attackable_tiles = false




















