extends Node2D

signal spin_finished(result, node)

var items: Array[String] = []
var label_height := 16
var palette = [Color(0.9, 0.3, 0.3), Color(0.3, 0.7, 0.9), Color(0.3, 0.9, 0.4), Color(0.9, 0.9, 0.1) ]
var styles: Array[StyleBox] = []
var vbox : VBoxContainer
var spinning : bool = false
var chosen = 0

var total_time = 2.0

var children
var size

var result: String

func _ready() -> void:
	setup()

func setup():
	randomize()
	vbox = $Container/VBoxContainer
	for color in palette:
		var stylebox = StyleBoxFlat.new()
		stylebox.bg_color = color
		styles.append(stylebox)
	_populate_vbox()

func set_symbols(array):
	items = array

func clear_vbox():
	if len(vbox.get_children()) != 0:
		for i in vbox.get_children():
			vbox.remove_child(i)
			i.queue_free()

func _populate_vbox():
	if items.is_empty():
		return
	var repeat_amount: int = 20/items.size()
	clear_vbox()
	for cycle in range(repeat_amount):
		for index in range(items.size()):
			var label = Label.new()
			label.text = items[index%items.size()]
			#label.add_theme_stylebox_override("normal", styles[index%4])
			label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			label.size_flags_vertical = Control.SIZE_FILL
			vbox.add_child(label)

func spin():
	if items.is_empty() or spinning:
		return
	var loops = randi() % 48 + 24
	
	chosen = await spin_slot(chosen, loops)
	result = children[chosen].text
	spin_finished.emit(result, self)

func spin_slot(prev_index: int, loops: int) -> int:
	spinning = true
	children = vbox.get_children()
	size = children.size()

	var base_delay = total_time / loops  # guarantees total = 2 sec

	# Clear previous highlight
	children[prev_index].add_theme_stylebox_override("normal", StyleBox.new())

	var index := prev_index

	for i in range(loops):
		var t := float(i) / (loops - 1)  # 0 → 1
		var eases := pow(t, 2)             # ease-out
		var delay = lerp(base_delay * 0.1, base_delay * 2.0, eases)

		index = (index + 1) % size

		var prev = (index - 1 + size) % size
		children[prev].add_theme_stylebox_override("normal", StyleBox.new())
		children[index].add_theme_stylebox_override("normal", styles[0])

		await get_tree().create_timer(delay).timeout

	spinning = false
	return index
