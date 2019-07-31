extends Node

const _skill_panel_prefab = preload("res://UI/CombatPanels/Skills/SkillPanel.tscn")

var _skill_menu
var _skill

func initialize(skill_menu, skill):
	_skill_menu = skill_menu
	_skill = skill
	
	$SkillName.text = skill._skill_name
	$SkillCost.text = str(skill._skill_cost)



# Bootstrap


func on_item_click(event):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		open_panel()


func open_panel():
	_skill_menu._current_skill_panel = _skill_panel_prefab.instance()
	_skill_menu.add_child(_skill_menu._current_skill_panel)
	_skill_menu._current_skill_panel.show()
	_skill_menu._current_skill_panel.initialize(_skill)
