extends Node2D

var _overseer


var _main_camera

var _inspect_button
var _move_button
var _attack_button
var _skill_button
var _pass_button

var _skill_menu




# Bootstrap

func inititalize():
	_overseer = get_parent()
	load_main_camera()
	load_buttons()
	load_skill_menu()


func load_main_camera():
	_main_camera = get_child(0)
	position = Vector2(16*7, 16*7) #ui manager is a container for all ui elements

func load_buttons():
	_inspect_button = get_child(1)
	_move_button = get_child(2)
	_attack_button = get_child(3)
	_skill_button = get_child(4)
	_pass_button = get_child(5)

func load_skill_menu():
	_skill_menu = get_child(6)
	_skill_menu.hide()





# Logic

func _process(_delta):
	if Input.is_action_pressed("camera_up"):
		position.y -= 1
	if Input.is_action_pressed("camera_down"):
		position.y += 1
	if Input.is_action_pressed("camera_left"):
		position.x -= 1
	if Input.is_action_pressed("camera_right"):
		position.x += 1
	_main_camera.align() #remove stuterring in camera movement




# Button Management

func move_button_was_pressed():
	_overseer.move_button()

func attack_button_was_pressed():
	_overseer.attack_button()

func skill_button_was_pressed():
	_overseer.skill_button()

func inspect_button_was_pressed():
	_overseer.inspect_button()

func pass_button_was_pressed():
	_overseer.pass_button()





# Skills

func assign_current_hero_skills(current_hero):
	_skill_menu.assign_current_hero_skills(current_hero._skills._skill_list)

func clear_skill_list():
	_skill_menu.clear_skill_list()

func show_skill_menu():
	_skill_menu.show()

func hide_skill_menu():
	_skill_menu.hide()
	_skill_menu.close_skill_panel()

func on_skill_click(tile):
	_skill_menu.on_tile_click(tile)


















