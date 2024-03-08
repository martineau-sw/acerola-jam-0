extends Node

@export var dialogue_resource: DialogueResource

var line_queue = []
var is_active = false
var is_printing = false

signal load_dialogue(resource: DialogueResource)
signal next_line(line: String)
signal end_dialogue

signal box_visible(state: bool)
signal dialogue_activated
signal dialogue_deactivated

func _ready():
	load_dialogue.connect(func(resource): _load_dialogue(resource))
	end_dialogue.connect(func(): _end_dialogue())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(Input.is_action_just_pressed(&"interact")):
		interact()

func interact():
	if(dialogue_resource == null || line_queue.is_empty()):
		_end_dialogue()
		return
		
	if is_active: 
		next_line.emit(line_queue.pop_front())
		return
		
	_initiate_dialogue()

func _load_dialogue(resource: DialogueResource):
	_clear_dialogue()
	dialogue_resource = resource
	_enqueue_all()

func _clear_dialogue():
	line_queue.clear()
	dialogue_resource = null

func _enqueue_all():
	for line in dialogue_resource.lines:
		line_queue.push_back(line)
	
func _initiate_dialogue():
	next_line.emit(line_queue.pop_front())
	is_active = true
	dialogue_activated.emit()
	box_visible.emit(true)
	
func _end_dialogue():
	_clear_dialogue()
	is_active = false
	dialogue_deactivated.emit()
	box_visible.emit(false)


