extends Node

var _overseer
var _parent_class

var _skill_list = []

# Bootstrap

func initialize(overseer, parent_class):
	_overseer = overseer
	_parent_class = parent_class


func add_skill(skill):
	skill.initialize(_overseer, _parent_class)
	_skill_list.append(skill)

func get_skill():
	return _skill_list[0]

func on_turn_start():
	for skill in _skill_list:
		skill.on_turn_start()


