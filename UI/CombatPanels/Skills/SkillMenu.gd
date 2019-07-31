extends Node

const _list_item_prefab = preload("res://UI/CombatPanels/Skills/SkillMenuItem.tscn")

var _current_hero_skills = []
var _current_skill_panel


# Bootstrap

func assign_current_hero_skills(current_hero_skills):
	_current_hero_skills = current_hero_skills
	for skill in _current_hero_skills:
		add_skill_to_list(skill)



# Manipulators

func clear_skill_list():
	for child in $ScrollContainer/List.get_children():
		child.queue_free()


func add_skill_to_list(skill):
	var item_instance = _list_item_prefab.instance()
	item_instance.initialize(self, skill)
	$ScrollContainer/List.add_child(item_instance)
	item_instance.rect_min_size = Vector2(164, 32)

func close_skill_panel():
	if _current_skill_panel != null:
		_current_skill_panel.close_panel()



func on_tile_click(tile):
	if _current_skill_panel != null:
		_current_skill_panel.on_tile_click(tile)






