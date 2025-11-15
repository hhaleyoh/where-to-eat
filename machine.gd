extends Node2D

const reel_preload = preload("res://reel.tscn")

var symbols: Array[String]
var spinning = false
var reel_count: int = 1
var results = []
var last_reel: Node2D

@onready var oguri: Area2D = $oguri_cap
@onready var reel_container: Node2D = $reelcontainer
#@onready var reel_container: HBoxContainer = $Control/reelcontainer

func _ready():
	randomize()
	$options.text_changed.connect(_on_options_changed)
	$reelcount.value_changed.connect(_value_changed)
	_on_options_changed()   # load initial values
	

func _on_options_changed():
	var raw = $options.text.split("\n")
	var cleaned: Array[String] = []

	for line in raw:
		var s = line.strip_edges()
		if s != "":
			cleaned.append(s)

	symbols = cleaned
	update_reels()

func _on_button_pressed() -> void:
	spin()

func _value_changed(val) -> void:
	reel_count = int(val)
	update_reels()

func update_reels():
	if len(reel_container.get_children()) != 0:
		for i in reel_container.get_children():
			reel_container.remove_child(i)
			i.queue_free()
	#var window_size = DisplayServer.window_get_size()
	var window_size = Vector2i(900,600)
	var reel_space = window_size.x/3
	for index in range(reel_count):
		var reel = reel_preload.instantiate()
		var x_pos = reel_space + (((window_size.x - reel_space)/reel_count)*index + ((window_size.x - reel_space)/reel_count)*(index+1))/2
		reel.set_symbols(symbols)
		reel.setup()
		reel.position = Vector2(x_pos, window_size.y/2)
		reel.connect("spin_finished", Callable(self, "_on_spin_finished"))
		reel_container.add_child(reel)
		last_reel = reel

func spin():
	if spinning:
		return
	spinning = true
	results = []
	for i in reel_container.get_children():
		i.spin()
		await get_tree().create_timer(0.1).timeout
	for reel in reel_container.get_children():
		await reel
	oguri.respond(symbols, reel_count, $checkbox.button_pressed)

func check_respin():
	if $checkbox.button_pressed:
		var first = results[0]
		for s in results:
			if s != first:
				spinning = false
				spin()
	else:
		finished_spinning()
		

func finished_spinning():
	pass

func _on_spin_finished(result, node):
	results.append(result)
	if last_reel == node:
		check_respin()
		spinning = false
