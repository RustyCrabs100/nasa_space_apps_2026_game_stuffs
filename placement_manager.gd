extends CanvasLayer

@export var available_builds: Array[BuildingData]

@onready var grid = get_node_or_null("main_panel/VBoxContainer/ScrollContainer/GridContainer")
@onready var funds_label = get_node_or_null("main_panel/VBoxContainer/HBoxContainer/funds_label")
@onready var constructables_label = get_node_or_null("main_panel/VBoxContainer/HBoxContainer/constructables_label")
@onready var error_label = %error_label

var placement_controller: Node3D
var camera: Camera3D
var buildings_container: Node3D

func setup(cam: Camera3D, buildings: Node3D) -> void:
	camera = cam
	buildings_container = buildings

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_resources()
	generate_building_buttons()
	
func update_resources() -> void:
	funds_label.text = "Funds: $%d" % GameManager.funds["amount"]
	constructables_label.text = "Constructables: %d" % GameManager.constructables["amount"]

func generate_building_buttons() -> void: 
	print("building buttons")
	print("Grid Size: ", grid.size)
	print("Scroll Size: ", grid.get_parent().size)
	print("Children: ", grid.get_child_count())
	for building in available_builds:
		var button = Button.new()
		button.custom_minimum_size = Vector2(160, 150)
		
		var container = VBoxContainer.new()
		container.alignment = BoxContainer.ALIGNMENT_CENTER
		
		var image = TextureRect.new()
		image.custom_minimum_size = Vector2(100, 85)
		image.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		
		if !building.building_icon == null:
			image.texture = building.building_icon
			
		var title = Label.new()
		if building.building_name == null:
			get_tree().quit(1)
		title.text = building.building_name
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		var cost = Label.new()
		cost.text = "$%d | Constructables: %d" % [
			building.money_cost,
			building.constructable_cost
		]
		cost.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		container.add_child(image)
		container.add_child(title)
		container.add_child(cost)
		
		button.add_child(container)
		button.text = title.text
		
		button.pressed.connect(_on_building_selected.bind(building))
		
		
		grid.add_child(button)
		
		print("Added button: ", button)
		print("Grid Child Count: ", grid.get_child_count())
		print("Button in tree: ", button.is_inside_tree())

func _on_building_selected(building: BuildingData) -> void:
	if GameManager.funds["amount"] < building.money_cost:
		error_label.text = "Building Costs too much!"
		return
		
	if GameManager.constructables["amount"] < building.constructable_cost:
		error_label.text = "Building Materials too much!"
		return
		
	print("Selected: ", building.building_name)
	
	start_placement(building)
	
func start_placement(building: BuildingData) -> void:
	if placement_controller == null:
		var controller_script = preload("res://placement_controller.gd")
		
		placement_controller = Node3D.new()
		placement_controller.set_script(controller_script)
		
		get_tree().current_scene.add_child(placement_controller)
		
		placement_controller.setup(camera, buildings_container)
		placement_controller.start_placement(building)
		
		hide()

func reopen_menu() -> void:
	show()
	update_resources()
	error_label.text = ""
	
func _exit_tree() -> void:
	if is_instance_valid(placement_controller):
		placement_controller.queue_free()
