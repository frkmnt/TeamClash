extends Node2D

#warning-ignore:unused_class_variable
var _coordinates
var _basic_attack
var _attributes
var _modifiers
var _skills


# Meta Info
var _calculate_moveable_tiles = true
var _moveable_tiles = []

var _calculate_attackable_tiles = true
var _attackable_tiles = []

var _remaining_speed


# ===Bootstrap===

func initialize(overseer):
	inititalize_attributes()
	inititalize_basic_attack()
	inititalize_modifiers()
	inititalize_skills(overseer)
	
	_remaining_speed = _attributes._speed


func inititalize_attributes():
	var attributes_prefab = preload("res://Party/Utils/Attributes.gd")
	_attributes = attributes_prefab.new()
	_attributes.initialize(6, 6, 12)


func inititalize_basic_attack():
	var basic_attack_prefab = preload("res://Party/Utils/BasicAttack.gd")
	_basic_attack = basic_attack_prefab.new()
	_basic_attack.initialize(3, 0, _attributes._magical_damage, 0, 3) #range, damage values, cost


func inititalize_modifiers():
	var modifiers_prefab = preload("res://Party/Modifiers/ModifierManager.gd")
	_modifiers = modifiers_prefab.new()
	_modifiers.initialize(self)


func inititalize_skills(overseer):
	var skills_prefab = preload("res://Party/Skills/SkillManager.gd")
	_skills = skills_prefab.new()
	_skills.initialize(overseer, self)
	var fireball = preload("res://Party/Skills/SkillList/Fireball.gd")
	_skills.add_skill(fireball.new())
	var arcane_blast = preload("res://Party/Skills/SkillList/ArcaneBlast.gd")
	_skills.add_skill(arcane_blast.new())
	var arcane_downfall = preload("res://Party/Skills/SkillList/ArcaneDownfall.gd")
	_skills.add_skill(arcane_downfall.new())
	var magic_missiles = preload("res://Party/Skills/SkillList/MagicMissiles.gd")
	_skills.add_skill(magic_missiles.new())




# ===Turn Management===

func start_turn():
	_remaining_speed = _attributes._speed
	_modifiers.on_turn_start()
	_skills.on_turn_start()

func end_turn():
	_modifiers.on_turn_end()
	_moveable_tiles.clear()
	_calculate_moveable_tiles = true
	_attackable_tiles.clear()
	_calculate_attackable_tiles = true





# Action Management

func on_move():
	_calculate_attackable_tiles = true
	_modifiers.on_move()
	_skills.on_move()







func get_basic_attack():
	return _basic_attack

func receive_attack(attack):
	_attributes.receive_attack(attack)
	print("Current HP ", _attributes._current_health)


func receive_skill(skill):
	_modifiers.on_receive_skill(skill)
	skill.apply_skill(self)











