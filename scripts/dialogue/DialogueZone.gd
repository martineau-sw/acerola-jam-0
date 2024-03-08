class_name DialogueZone
extends Area3D

@export var dialogue: DialogueResource

@onready var prompt = $InteractLabel

func _ready():
	prompt.hide()
	DialogueManager.dialogue_activated.connect(func(): prompt.hide())
	
func _on_body_entered(body):
	prompt.show()
	if(body.is_in_group("Player")):
		DialogueManager.load_dialogue.emit(dialogue)

func _on_body_exited(body):
	if(body.is_in_group("Player")):
		DialogueManager.end_dialogue.emit()

