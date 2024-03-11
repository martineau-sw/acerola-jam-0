extends CanvasLayer

@onready var brain_button = $Opponent/Brain
@onready var eye_r_button = $Opponent/RightEye
@onready var eye_l_button = $Opponent/LeftEye
@onready var mouth_button = $Opponent/Mouth

@onready var attack_button = $Player/UI/Panels/Options/Margins/Buttons/Attack
@onready var defend_button = $Player/UI/Panels/Options/Margins/Buttons/Defend
@onready var nothing_button = $Player/UI/Panels/Options/Margins/Buttons/Nothing

@onready var ego_label = $Player/UI/Panels/Stats/Margins/Labels/Ego/Value
@onready var sol_label = $Player/UI/Panels/Stats/Margins/Labels/Soul/Value

@onready var background: FastNoiseLite = $ColorFilter/Background.texture.noise
# Called when the node enters the scene tree for the first time.
func _ready():
	BattleManager.battle_started.connect(func(): _on_start())
	BattleManager.phase_action_select.connect(func(): _on_action_select())
	BattleManager.phase_target_select.connect(func(): _on_target_select())
	BattleManager.phase_resolve.connect(func(): _on_resolve())
	BattleManager.phase_render.connect(func(): _on_render())
	BattleManager.battle_ended.connect(func(outcome): _on_end(outcome))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	ego_label.text = str(BattleManager.player.ego)
	sol_label.text = str(BattleManager.player.sol)

	background.fractal_ping_pong_strength = sin(Time.get_ticks_msec() / 5000.) * 3 + 4
	
func _on_start():
	pass

func _on_action_select():
	_disable_actions(false)
	_disable_targets(true)
	pass

func _on_target_select():
	_disable_actions(true)
	_disable_targets(false)
	pass

func _on_resolve():
	pass

func _on_render():
	pass
	
func _on_end(outcome):
	print(outcome)
	pass

func _on_attack_button_button_up():
	BattleManager.select_action.emit(BattleManager.Action.ATTACK)

func _on_defend_button_button_up():
	BattleManager.select_action.emit(BattleManager.Action.DEFEND)
	
func _on_nothing_button_button_up():
	BattleManager.select_action.emit(BattleManager.Action.NOTHING)

func _on_brain_button_up():
	BattleManager.select_target.emit(BattleManager.Target.BRAIN)

func _on_right_eye_pressed():
	BattleManager.select_target.emit(BattleManager.Target.EYE_R)

func _on_left_eye_pressed():
	BattleManager.select_target.emit(BattleManager.Target.EYE_L)

func _on_mouth_pressed():
	BattleManager.select_target.emit(BattleManager.Target.MOUTH)


func _disable_targets(disabled: bool):
	brain_button.disabled = disabled
	eye_r_button.disabled = disabled
	eye_l_button.disabled = disabled
	mouth_button.disabled = disabled

func _disable_actions(disabled: bool):
	attack_button.disabled = disabled
	defend_button.disabled = disabled
	nothing_button.disabled = disabled
