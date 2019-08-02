extends Node

const _PIXEL_RATIO = 16

var _map_generator
var _select_highlight
var _confirm_highlight
var _current_hero_highlight

var _tilemap = {}
var _highlighted_tiles = []
var _confirm_tiles = []
var _current_hero_tile




# ===Bootstrap===

func initialize():
	_map_generator = $MapGenerator
	generate_random_map()
	initialize_sprites()

func generate_random_map():
	_map_generator.initialize()
	_tilemap = _map_generator.tileset
	_map_generator.delete_generator()

func initialize_sprites():
	_select_highlight = preload("res://Map/Tiles/SelectHighlight.tscn")
	_confirm_highlight = preload("res://Map/Tiles/ConfirmHighlight.tscn")
	_current_hero_highlight = preload("res://Map/Tiles/CurrentHeroHighlight.tscn")




# ===Tile Management===

func inspect_tile(coordinates):
	var tile = _tilemap.get(coordinates)
	return tile._description

func get_tile_with_coordinates(coordinates):
	return _tilemap.get(coordinates)

func get_tile_position_with_coordinates(coordinates): #offset y to center sprite on tile
	return Vector2(coordinates.x*_PIXEL_RATIO, (coordinates.y*_PIXEL_RATIO)-3)

func is_tile_moveable(coordinates):
	return _tilemap.get(coordinates)._is_moveable






# ===Highlight Management===

# Add
func highlight_current_hero_tile(hero):
	var highlight_instance = _current_hero_highlight.instance()
	var current_tile = _tilemap.get(hero._coordinates)
	current_tile.add_current_hero_highlight(highlight_instance)
	_current_hero_tile = current_tile

func highlight_tile_select(tile):
	var highlight_instance = _select_highlight.instance()
	tile.add_highlight(highlight_instance)
	_highlighted_tiles.append(tile)

func highlight_tile_confirm(tile):
	var highlight_instance = _confirm_highlight.instance()
	tile.add_highlight(highlight_instance)
	_confirm_tiles.append(tile)


func highlight_tiles_select(tile_list):
	var highlight_instance
	for tile in tile_list:
		highlight_instance = _select_highlight.instance()
		tile.add_highlight(highlight_instance)
		_highlighted_tiles.append(tile)

func highlight_tiles_confirm(tile_list):
	var highlight_instance
	for tile in tile_list:
		highlight_instance = _confirm_highlight.instance()
		tile.add_highlight(highlight_instance)
		_confirm_tiles.append(tile)




# Remove
func remove_highlight_from_tile(tile):
	tile.remove_highlight()
	_highlighted_tiles.remove(_highlighted_tiles.find(tile))

func remove_highlight_from_tiles(tile_list):
	for tile in tile_list:
		tile.remove_highlight()
		_highlighted_tiles.remove(_highlighted_tiles.find(tile))

func remove_highlight_from_select_tiles():
	for tile in _highlighted_tiles:
		tile.remove_highlight()
	_highlighted_tiles.clear()

func remove_highlight_from_confirm_tiles():
	for tile in _confirm_tiles:
		tile.remove_highlight()
	_confirm_tiles.clear()

func remove_current_hero_highlight():
	if _current_hero_tile != null:
		_current_hero_tile.remove_current_hero_highlight()
		_current_hero_tile = null





# ===Hero Management===

func is_hero_on_tile(coordinates):
	if _tilemap.get(coordinates)._tile_hero != null:
		return true
	return false

func set_hero_on_tile(coordinates, hero): #offset y to center sprite on tile
	_tilemap.get(coordinates).set_hero_on_tile(hero)
	hero.position = Vector2(coordinates.x*_PIXEL_RATIO, (coordinates.y*_PIXEL_RATIO)-3)

func remove_hero_from_tile(coordinates):
	_tilemap.get(coordinates).remove_hero_from_tile()

func move_hero_to_tile(tile, hero):
	if tile in hero._moveable_tiles \
	and tile._is_moveable:
		tile.set_hero_on_tile(hero)
		hero.position = Vector2(tile._coordinates.x*_PIXEL_RATIO, \
								(tile._coordinates.y*_PIXEL_RATIO)-3)
		hero._remaining_speed = _speed_grid[tile]





# ===Object Management===

func set_object_on_tile(coordinates, object):
	_tilemap.get(coordinates).add_object_to_tile(object)
	object.position = Vector2(coordinates.x*_PIXEL_RATIO, (coordinates.y*_PIXEL_RATIO)-3)

func remove_object_from_tile(coordinates, object):
	_tilemap.get(coordinates).remove_object_from_tile(object)





# ===Tile Search===

func get_tiles_in_range(origin, radius):
	var start_x = origin.x - radius
	var end_x = origin.x + radius+1
	var start_y = origin.y - radius
	var end_y = origin.y + radius+1
	var tiles_in_range = []
	
	for x in range(start_x, end_x):
		for y in range(start_y, end_y):
			if _tilemap.has(Vector2(x,y)):
				tiles_in_range.append(_tilemap.get(Vector2(x,y)))
	
	return tiles_in_range


func get_attackable_tiles_in_range(origin, radius):
	var start_x = origin.x - radius
	var end_x = origin.x + radius+1
	var start_y = origin.y - radius
	var end_y = origin.y + radius+1
	var tiles_in_range = []
	
	for x in range(start_x, end_x):
		for y in range(start_y, end_y):
			if _tilemap.has(Vector2(x,y)):
				var tile = _tilemap.get(Vector2(x,y))
				if tile._tile_hero != null or tile._tile_object != null:
					tiles_in_range.append(_tilemap.get(Vector2(x,y)))
	
	return tiles_in_range



var _speed_grid = {} # records the least ammount of speed needed to reach each tile

func get_moveable_tiles(origin, speed):
	_speed_grid.clear()
	_tilemap.get(origin)._is_moveable = true # set the tile w/ the hero as moveable
	calculate_moveable_tiles(origin, speed+1) # increment speed bc/ of the 1st tile
	_tilemap.get(origin)._is_moveable = false
	return _speed_grid.keys() # returns list with the origin tile included

func calculate_moveable_tiles(current_coordinates, speed):
	speed -= 1
	if speed >= 0 and _tilemap.has(current_coordinates):
		var current_tile = _tilemap.get(current_coordinates)
		if current_tile._is_moveable:
			if _speed_grid.has(current_tile):
				if speed > _speed_grid[current_tile]:
					_speed_grid[current_tile] = speed
				else: return
			else:
				_speed_grid[current_tile] = speed
			
			var temp_coords = current_coordinates
			
			temp_coords = Vector2(current_coordinates.x, current_coordinates.y +1) #UP
			if _tilemap.has(temp_coords):
				calculate_moveable_tiles(temp_coords, speed)
			
			temp_coords = Vector2(current_coordinates.x +1, current_coordinates.y +1) #UP-RIGHT
			if _tilemap.has(temp_coords):
				calculate_moveable_tiles(temp_coords, speed)
			
			temp_coords = Vector2(current_coordinates.x +1, current_coordinates.y) #RIGHT
			if _tilemap.has(temp_coords):
				calculate_moveable_tiles(temp_coords, speed)
			
			temp_coords = Vector2(current_coordinates.x +1, current_coordinates.y -1) #DOWN-RIGHT
			if _tilemap.has(temp_coords):
				calculate_moveable_tiles(temp_coords, speed)
			
			temp_coords = Vector2(current_coordinates.x, current_coordinates.y -1) #DOWN
			if _tilemap.has(temp_coords):
				calculate_moveable_tiles(temp_coords, speed)
			
			temp_coords = Vector2(current_coordinates.x -1, current_coordinates.y -1) #DOWN-LEFT
			if _tilemap.has(temp_coords):
				calculate_moveable_tiles(temp_coords, speed)
			
			temp_coords = Vector2(current_coordinates.x -1, current_coordinates.y) #LEFT
			if _tilemap.has(temp_coords):
				calculate_moveable_tiles(temp_coords, speed)
			
			temp_coords = Vector2(current_coordinates.x -1, current_coordinates.y +1) #UP-LEFT
			if _tilemap.has(temp_coords):
				calculate_moveable_tiles(temp_coords, speed)
	
	return
	













