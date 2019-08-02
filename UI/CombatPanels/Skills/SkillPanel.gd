extends Node

var _skill_menu 
var _skill
var _confirm_button

# Bootstrap queue_free

func initialize(skill):
	_skill_menu = get_parent()
	_skill = skill
	$Name.text = skill._skill_name
	$CostLabel/CostValue.text = str(skill._skill_cost)
	$TypeLabel/TypeValue.text = skill._skill_type 
	$Description.text = skill._skill_description
	
	_confirm_button = $ConfirmButton
	
	_skill.on_skill_select()
	if _skill.is_skill_confirmable():
		_confirm_button.disabled = false



func close_panel():
	_skill_menu._current_skill_panel = null
	_skill.on_skill_deselect()
	queue_free()



func on_tile_click(tile):
	if _skill.has_method("on_tile_click"):
		_skill.on_tile_click(tile)
		if _skill.is_skill_confirmable():
			_confirm_button.disabled = false
		else:
			_confirm_button.disabled = true

func on_skill_confirm():
	_skill.confirm_skill()
	close_panel()











