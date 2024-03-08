extends Node

@export var player: PlayerResource = preload("res://resources/test_player.tres")
@export var opponent: OpponentResource = preload("res://resources/test_opponent.tres")

var player_action: int
var player_target: int
var player_damage_mult = 1.

var opponent_action: int
var opponent_target: int
var opponent_damage_mult = 1.

signal battle_started

signal choose_action(choice: int)
signal choose_target(choice: int)

signal phase_action_select
signal phase_target_select
signal phase_resolve

signal battle_ended(outcome: int)

# Called when the node enters the scene tree for the first time.
func _ready(): 
	

	
	choose_action.connect(
		func(action):
			player_action = action
			if(action == -1):
				start_phase_resolve()
				return
			start_phase_target_select()
	)
	
	choose_target.connect(
		func(target):
			player_target = target
			start_phase_resolve()
	)
	
	
	player.ego_empty.connect(
		func():
			end_battle(-1)
	)
	
	opponent.ego_empty.connect(func():end_battle(1))
	opponent.brain_empty.connect(func():end_battle(0))
	opponent.eye_r_empty.connect(func():end_battle(0))
	opponent.eye_l_empty.connect(func():end_battle(0))
	opponent.mouth_empty.connect(func():end_battle(0))
	
	start_phase_action_select()

func battle_start():
	print("battle started")
	battle_started.emit()

func start_phase_action_select():
	print("action select started")
	phase_action_select.emit()

func start_phase_target_select():
	print("target select started")
	phase_target_select.emit()

func start_phase_resolve():
	print("resolution started")
	phase_resolve.emit()
	
	opponent_action = (randi() % 3) - 1
	opponent_target = (opponent_action >= 0) if (randi() % 4) else -1
	
	if(player_action > opponent_action):
		player_do()
		opponent_do()
	elif(player_action == opponent_action):
		var flip = bool(randi() % 2)
		if flip:
			player_do()
			opponent_do()
		else:
			opponent_do()
			player_do()
	elif(opponent_action > player_action):
		opponent_do()
		player_do()
	
	start_phase_action_select()
		
func end_battle(outcome):
	print("battle ended")
	if(outcome == 1):
		player.sol += opponent.sol
	if(outcome == 0):
		player.ego_max += 5
	
	battle_ended.emit(outcome)
		


func player_attack():
	print("player attacked")
	var damage = player_damage_mult
	
	if(opponent_action == 1):
		if(opponent_target == player_target):
			damage = 0
			return
		damage = player_damage_mult / 2
	
	# Brain
	if (player_target == 0):
		damage = player.men * player_damage_mult
		opponent.brain_damaged.emit(damage)
	# Right eye
	elif (player_target == 1):
		damage = player.phy * player_damage_mult
		opponent.eye_r_damaged.emit(damage)
	# Left eye
	elif (player_target == 2):
		damage = player.phy * player_damage_mult
		opponent.eye_l_damaged.emit(damage)
	# Mouth
	elif (player_target == 3):
		damage = player.soc * player_damage_mult
		opponent.mouth_damaged.emit(damage)
		
	opponent.ego -= damage
	

func opponent_attack():
	print("opponent attacked")
	var damage = 0;
	
	if(opponent_target == 0):
		damage = opponent.men
	elif(opponent_target == 1):
		damage = opponent.phy
	elif(opponent_target == 2):
		damage = opponent.phy
	elif(opponent_target == 3):
		damage = opponent.soc
		
	damage *= opponent_damage_mult
	
	if(player_action == 1):
		if(player_target == opponent_target):
			damage = 0
			return
		damage = damage / 2
	
	player.ego_damaged.emit(damage)


func player_do():
	print("player doing")
	if(player_action == -1):
		player_damage_mult += player.sol * 0.2
		return
	if(player_action == 0):
		player_attack()
		return
	if(player_action == 1):
		return

func opponent_do():
	print("opponent doing")
	if(opponent_action == -1):
		opponent_damage_mult += opponent.sol * 0.2
		return
	if(opponent_action == 0):
		opponent_attack()
		opponent_damage_mult = 1.
		return
	if(opponent_action == 1):
		return
