extends Node

const _PIXEL_RATIO = 16 #bit
const _MAP_WIDTH = 15
const _MAP_HEIGHT = 15

var sprite_map = {}
var tile_prefab

var tileset= {}









func inititalize():
	load_sprites()
	generate_map()


func load_sprites():
	var sprite_list
	
	sprite_map["wall_up"] = []
	sprite_list = sprite_map.get("wall_up")
	sprite_list.append(preload("res://Sprites/Map/Dungeon Tiles/sprite_001.png"))
	sprite_list.append(preload("res://Sprites/Map/Dungeon Tiles/sprite_002.png"))
	sprite_list.append(preload("res://Sprites/Map/Dungeon Tiles/sprite_003.png"))
	
	sprite_map["wall_left"] = []
	sprite_list = sprite_map.get("wall_left")
	sprite_list.append(preload("res://Sprites/Map/Dungeon Tiles/sprite_005.png"))
	sprite_list.append(preload("res://Sprites/Map/Dungeon Tiles/sprite_015.png"))
	
	sprite_map["wall_right"] = []
	sprite_list = sprite_map.get("wall_right")
	sprite_list.append(preload("res://Sprites/Map/Dungeon Tiles/sprite_000.png"))
	sprite_list.append(preload("res://Sprites/Map/Dungeon Tiles/sprite_010.png"))
	
	sprite_map["wall_down"] = []
	sprite_list = sprite_map.get("wall_down")
	sprite_list.append(preload("res://Sprites/Map/Dungeon Tiles/sprite_041.png"))
	sprite_list.append(preload("res://Sprites/Map/Dungeon Tiles/sprite_042.png"))
	sprite_list.append(preload("res://Sprites/Map/Dungeon Tiles/sprite_052.png"))
	
	sprite_map["corner_up_left"] = []
	sprite_list = sprite_map.get("corner_up_left")
	sprite_list.append(preload("res://Sprites/Map/Dungeon Tiles/sprite_050.png"))
	sprite_list.append(preload("res://Sprites/Map/Dungeon Tiles/sprite_054.png"))
	
	sprite_map["corner_up_right"] = []
	sprite_list = sprite_map.get("corner_up_left")
	sprite_list.append(preload("res://Sprites/Map/Dungeon Tiles/sprite_050.png"))
	sprite_list.append(preload("res://Sprites/Map/Dungeon Tiles/sprite_054.png"))
	
	sprite_map["corner_down_left"] = []
	sprite_list = sprite_map.get("corner_down_left")
	sprite_list.append(preload("res://Sprites/Map/Dungeon Tiles/sprite_040.png"))
	
	sprite_map["corner_down_right"] = []
	sprite_list = sprite_map.get("corner_down_right")
	sprite_list.append(preload("res://Sprites/Map/Dungeon Tiles/sprite_045.png"))
	
	sprite_map["floor"] = []
	sprite_list = sprite_map.get("floor")
	sprite_list.append(preload("res://Sprites/Map/Dungeon Tiles/sprite_006.png"))
	sprite_list.append(preload("res://Sprites/Map/Dungeon Tiles/sprite_007.png"))
	sprite_list.append(preload("res://Sprites/Map/Dungeon Tiles/sprite_008.png"))
	sprite_list.append(preload("res://Sprites/Map/Dungeon Tiles/sprite_009.png"))
	
	
	
	tile_prefab = preload("res://Map/Tiles/Floor.tscn")


func delete_generator():
	queue_free()




func generate_map():
	for x in range(_MAP_WIDTH):
		for y in range(_MAP_HEIGHT):
			create_new_tile(x, y, "floor")



func create_new_tile(x, y, tile_type):
	var tile = generate_tile(x, y, tile_type)
	insert_tile_in_grid(tile)

func get_random_sprite_of_type(sprite_type):
	var sprite_list = sprite_map.get(sprite_type)
	randomize()
	return sprite_list[floor(rand_range(0, sprite_list.size()))]


func generate_tile(x, y, tile_type):
	var tile = tile_prefab.instance()
	tile.position = Vector2(x*_PIXEL_RATIO, y*_PIXEL_RATIO)
	get_parent().add_child(tile)
	tile.set_coordinates(x, y)
	tile.set_sprite(get_random_sprite_of_type(tile_type))
	return tile


func insert_tile_in_grid(tile):
	tileset[tile._coordinates] = tile







