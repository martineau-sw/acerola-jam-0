extends CanvasLayer

@onready var text_box = $BoxVAlign/BoxHAlign/Box/TextVAlign/HBoxContainer/Text

var _visible

func _ready():
	DialogueManager.next_line.connect( func(text): replace_text(text) )
	DialogueManager.box_visible.connect( 
		func(state): 
			if state: 
				if not _visible: 
					$AnimationPlayer.play("dialogue_show")
					_visible = true
					
			else: 
				if _visible:
					$AnimationPlayer.play("dialogue_hide")
					_visible = false
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	scroll()
	
func scroll():
	if(text_box.visible_ratio > 1. || text_box.get_total_character_count() == 0):
		return
	text_box.visible_ratio += 1. / text_box.get_total_character_count()

func replace_text(text: String):
	text_box.visible_ratio = 0.
	text_box.text = text

