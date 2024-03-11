extends Node

@export var player: PlayerResource = preload("res://resources/test_player.tres")
@export var opponent: OpponentResource = preload("res://resources/test_opponent.tres")

var round_number: int

var player_action: Action
var player_target: Target
var player_damage_mult = 1.

var opponent_action: Action
var opponent_target: Target
var opponent_damage_mult = 1.

signal battle_started
signal phase_action_select
signal phase_target_select
signal phase_resolve
signal phase_render
signal battle_ended(outcome: int)

signal select_action(action: Action)
signal select_target(target: Target)
signal fx_rendered

signal enqueue(animation_name: StringName)

enum Action {
	NONE = -2,
	NOTHING = -1,
	ATTACK = 0,
	DEFEND = 1
}

enum Target {
	NONE = -1,
	BRAIN,
	EYE_R,
	EYE_L,
	MOUTH
}

# Called when the node enters the scene tree for the first time.
func _ready(): 
	
	battle_started.connect(func(): _on_start())
	phase_action_select.connect(func(): _on_action_select())
	phase_target_select.connect(func(): _on_target_select())
	phase_resolve.connect(func(): _on_resolve())
	phase_render.connect(func(): _on_render())
	battle_ended.connect(func(outcome): _on_end(outcome))
	
	select_action.connect(func(action): _on_select_action(action))
	select_target.connect(func(target): _on_select_target(target))
	
	opponent.ego_empty.connect(func(): battle_ended.emit(1))
	opponent.brain_empty.connect(func(): battle_ended.emit(0))
	opponent.eye_r_empty.connect(func(): battle_ended.emit(0))
	opponent.eye_l_empty.connect(func(): battle_ended.emit(0))
	opponent.mouth_empty.connect(func(): battle_ended.emit(0))
	
	player.ego_empty.connect(
		func():
			battle_ended.emit(-1)
	)
	
	battle_started.emit()
	
func _on_start():
	print("battle started")
	
	round_number = 0
	
	player_damage_mult = 0.6
	opponent_damage_mult = 0.6
	player_action = Action.NONE
	player_target = Target.NONE
	opponent_action = Action.NONE
	opponent_target = Target.NONE
	
	phase_action_select.emit()

func _on_action_select():
	print("round: %d" % round_number)
	print("action selection phase started")
	await select_action
	
func _on_select_action(action: Action):
	print("action selected: %s" % action)
	player_action = action
	if action == Action.NOTHING: phase_resolve.emit(); return
	phase_target_select.emit()
	
func _on_target_select():
	print("target selection phase started")
	await select_target

func _on_select_target(target: Target):
	print("target selected: %s" % target)
	player_target = target 
	phase_resolve.emit() 

func _on_resolve():
	print("resolution phase started")
	
	_opponent_turn()
		
	if player_action > opponent_action: _player_initiative()
	elif player_action == opponent_action: _roll_initiative()
	elif opponent_action > player_action: _opponent_initiative()
	
	player_action = Action.NONE
	player_target = Target.NONE
	opponent_action = Action.NONE
	opponent_target = Target.NONE
	
	round_number += 1
	phase_render.emit()

func _on_render():
	print("rendering fx")
	await fx_rendered
	phase_action_select.emit()

func _on_end(outcome):
	print("battle ended")
	
	match outcome:
		-1: pass # TODO lose outcome
		0: player.ego_max += 5 
		1: player.sol += opponent.sol
	
	battle_ended.emit(outcome)
		

func _player_attack():
	print("player attacked")
	
	var damage
	
	if(opponent_action == Action.DEFEND):
		player_damage_mult = float(opponent_target == player_target) if 0. else player_damage_mult / 2.
	
	match player_target:
		Target.BRAIN: damage = player.men; opponent.brain_damaged.emit(damage)
		Target.EYE_R: damage = player.phy; opponent.eye_r_damaged.emit(damage)
		Target.EYE_L: damage = player.phy; opponent.eye_l_damaged.emit(damage)
		Target.MOUTH: damage = player.soc; opponent.mouth_damaged.emit(damage)
		
	opponent.ego_damaged.emit(damage * player_damage_mult)
	
	player_damage_mult = 0.6

func _opponent_attack():
	print("opponent attacked")
	var damage = 0;
	
	if player_action == 1:
		opponent_damage_mult = player_target == opponent_target if 0. else opponent_damage_mult / 2.0
	
	match opponent_target:
		Target.BRAIN: damage = opponent.men
		Target.EYE_R: damage = opponent.phy
		Target.EYE_L: damage = opponent.phy
		Target.MOUTH: damage = opponent.soc
	
	player.ego_damaged.emit(damage * opponent_damage_mult)
	
	opponent_damage_mult = 0.6


func _player_do():
	print("player doing")
	
	match player_action:
		-1: player_damage_mult += player.sol * 0.2
		0: _player_attack()
		1: return
	
	return

func _opponent_do():
	print("opponent doing")
	
	match opponent_action:
		-1: opponent_damage_mult += opponent.sol * 0.2
		0: _opponent_attack()
		1: return
		
	return
	
func _opponent_turn(): 
	opponent_action = ((randi() % 3) - 1) as Action
	opponent_target = (opponent_action >= 0) if (randi() % 4) else -1
	
func _player_initiative():
	_player_do()
	_opponent_do()

func _opponent_initiative():
	_opponent_do()
	_player_do()
	
func _roll_initiative():
	match randi() % 2:
		0: _player_initiative(); _opponent_initiative()
		1: _opponent_initiative(); _player_initiative()
