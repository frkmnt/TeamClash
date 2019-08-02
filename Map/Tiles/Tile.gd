extends Node2D



var _coordinates = Vector2()
var _description = "This is a tile."

var _tile_object = null
var _tile_hero = null
var _is_moveable = true

var _current_hero_highlight
var _tile_highlight



# Click Management

func on_click_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
    and event.button_index == BUTTON_LEFT \
    and event.is_pressed():
		get_parent().get_parent().tile_was_clicked(_coordinates)




# Getters/Setters

func set_coordinates(x, y):
	_coordinates = Vector2(x, y)


func set_sprite(sprite):
	var sprite_holder = $Sprite
	sprite_holder.texture = sprite


func is_hero_on_tile():
	return _tile_hero == null

func is_object_on_tile():
	return _tile_object == null





# Highlight

func add_current_hero_highlight(highlight):
	_current_hero_highlight = highlight
	add_child(highlight)

func remove_current_hero_highlight():
	_current_hero_highlight.queue_free()


func add_highlight(highlight):
	_tile_highlight = highlight
	add_child(highlight)


func remove_highlight():
	_tile_highlight.queue_free()







# Object/Hero Management

# Getters/Setters
func set_hero_on_tile(hero):
	hero._coordinates = _coordinates
	_tile_hero = hero
	_is_moveable = false

func remove_hero_from_tile():
	_tile_hero = null
	_is_moveable = true


func set_object_on_tile(object):
	object._coordinates = _coordinates
	_tile_object = object
	_is_moveable = false

func remove_object_from_tile():
	_tile_object = null
	_is_moveable = true


# Tile Interaction
func attack_tile(attack):
	if _tile_hero != null:
		_tile_hero.receive_attack(attack)
	elif _tile_object != null:
		_tile_object.receive_attack(attack)

func skill_tile(skill):
	if _tile_hero != null:
		_tile_hero.receive_skill(skill)
	elif _tile_object != null:
		_tile_object.receive_skill(skill)









