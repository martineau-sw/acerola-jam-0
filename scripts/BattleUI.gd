extends CanvasLayer

@onready var brain_button = $VBoxContainer/Control/Brain
@onready var eye_r_button = $VBoxContainer/Control/RightEye
@onready var eye_l_button = $VBoxContainer/Control/LeftEye
@onready var mouth_button = $VBoxContainer/Control/Mouth

@onready var attack_button = $VBoxContainer/Control2/HBoxContainer/BattleOptions/MarginContainer/HBoxContainer/AttackButton
@onready var defend_button = $VBoxContainer/Control2/HBoxContainer/BattleOptions/MarginContainer/HBoxContainer/DefendButton
@onready var nothing_button = $VBoxContainer/Control2/HBoxContainer/BattleOptions/MarginContainer/HBoxContainer/NothingButton

@onready var ego_label = $VBoxContainer/Control2/HBoxContainer/Stats/MarginContainer/VBoxContainer/EgoContainer/Label3
@onready var sol_label = $VBoxContainer/Control2/HBoxContainer/Stats/MarginContainer/VBoxContainer/SoulContainer/Label5

@onready var background: FastNoiseLite = $TextureRect.texture.noise
# Called when the node enters the scene tree for the first time.
func _ready():
	
	BattleManager.phase_action_select.connect(
		func():
			disable_actions(false)
	)
	
	BattleManager.phase_target_select.connect(
		func():
			disable_actions(true)
			disable_targets(false)
	)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ego_label.text = str(BattleManager.player.ego)
	sol_label.text = str(BattleManager.player.sol)

	background.fractal_ping_pong_strength = sin(Time.get_ticks_msec() / 5000.) * 3 + 4

func _on_attack_button_button_up():
	BattleManager.choose_action.emit(0)

func _on_defend_button_button_up():
	BattleManager.choose_action.emit(1)
	
func _on_nothing_button_button_up():
	BattleManager.choose_action.emit(-1)

func disable_targets(disabled: bool):
	mouth_button = disabled
	eye_r_button = disabled
	eye_l_button = disabled
	mouth_button = disabled

func disable_actions(disabled: bool):
	attack_button.disabled = disabled
	defend_button.disabled = disabled
	nothing_button.disabled = disabled


func _on_brain_button_up():
	BattleManager.choose_target.emit(0)


func _on_right_eye_pressed():
	BattleManager.choose_target.emit(1)


func _on_left_eye_pressed():
	BattleManager.choose_target.emit(2)


func _on_mouth_pressed():
	BattleManager.choose_target.emit(3)
