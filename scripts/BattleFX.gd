extends AnimationPlayer

var animation_queue = []

func _ready():
	
	play("idle")
	
	BattleManager.enqueue.connect(
		func(animation_name):
			animation_queue.push_back(animation_name)
	)
	
	BattleManager.phase_render.connect(
		func():
			if animation_queue.is_empty(): 
				BattleManager.fx_rendered.emit(); 
				
			play_all()
	)

func play_all():
	for animation in animation_queue:
		if animation == animation_queue[0]:
			play(animation)
		else:
			queue(animation)
		
func _on_animation_finished(animation_name: StringName):
	if(animation_name == animation_queue.back()):
		animation_queue.clear()
		clear_queue()
		BattleManager.fx_rendered.emit()
