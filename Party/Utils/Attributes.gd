extends Node

var is_dead = false


# Attributes
var _strength
var _dexterity
var _intelligence


# Stats
var _max_health 
var _current_health 

var _physical_damage 
var _magical_damage

var _physical_defense 
var _magical_defense 

var _speed
var _evasion




func initialize(strength, dexterity, intelligence):
	_strength = strength
	_max_health = strength*10
	_current_health = _max_health
	_physical_damage = strength*3
	_physical_defense = strength
	
	_dexterity = dexterity
	_speed = dexterity/2
	_evasion = dexterity
	
	_intelligence = intelligence
	_magical_damage = intelligence*3
	_magical_defense = intelligence*2






# Health Manipulation

func receive_attack(attack):
	var total_damage = 0
	total_damage += attack.get_physical_damage_with_reduction(_physical_defense)
	total_damage += attack.get_magical_damage_with_reduction(_magical_defense)
	total_damage += attack._raw_damage
	subtract_health(total_damage)


func add_health(value):
	_current_health += value
	if _current_health > _max_health:
		_current_health = _max_health

func fill_health():
		_current_health = _max_health

func subtract_health(value):
	_current_health -= value
	if _current_health < 0:
		_current_health = 0
		is_dead = true






# Stat/Attribute Manipulators 

func add_strength(value):
	_strength = add_stat(_strength, value)
	apply_strength_to_stats()

func subtract_strength(value):
	_strength = subtract_stat(_strength, value)
	apply_strength_to_stats()


func add_dexterity(value):
	_dexterity = add_stat(_dexterity, value)
	apply_dexterity_to_stats()

func subtract_dexterity(value):
	_dexterity = subtract_stat(_dexterity, value)
	apply_dexterity_to_stats()


func add_intelligence(value):
	_intelligence = add_stat(_intelligence, value)
	apply_intelligence_to_stats()

func subtract_intelligence(value):
	_intelligence = subtract_stat(_intelligence, value)
	apply_intelligence_to_stats()




#warning-ignore:unused_argument
func add_stat(stat, value):
	stat += value
	return stat

#warning-ignore:unused_argument
func subtract_stat(stat, value):
	stat -= value
	if stat < 1:
		stat = 1
	return stat




func apply_strength_to_stats():
	_max_health = _strength*10
	_physical_damage = _strength*3
	_physical_defense = _strength
	
	if _current_health > _max_health:
		_current_health = _max_health


func apply_dexterity_to_stats():
	_speed = _dexterity/2
	_evasion = _dexterity


func apply_intelligence_to_stats():
	_magical_damage = _intelligence*5
	_magical_defense = _intelligence*2












