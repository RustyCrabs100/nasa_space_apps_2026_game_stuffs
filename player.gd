extends Node3D

@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var location_text: Label = $CanvasLayer/location_text

@export_group("Camera Movement")
@export var orbit_sensitivity: float = 0.005
@export var pan_sensitivity: float = 0.05
@export var zoom_speed: float = 3.0
@export var move_speed: float = 20.0

@export_group("Placement System")
@export var placement_manager_scene: PackedScene
var placement_manager: CanvasLayer

@export_group("Resources System")
@export var resources_panel_scene: PackedScene
var resources_panel: CanvasLayer

var rotating := false
var panning := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	spring_arm.rotation.x = deg_to_rad(-45.0)
	spring_arm.spring_length = 30


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Vector3.ZERO
	
	if Input.is_key_pressed(KEY_W):
		direction.z += 1
		
	if Input.is_key_pressed(KEY_S): 
		direction.z -= 1
		
	if Input.is_key_pressed(KEY_A):
		direction.x -= 1
		
	if Input.is_key_pressed(KEY_D):
		direction.x += 1
		
	direction = direction.normalized()
	
	var forward = -global_transform.basis.z
	var right = global_transform.basis.x
	
	forward = forward.normalized()
	right = right.normalized()
	
	global_position += (
		(forward * direction.z + right * direction.x)
		* move_speed * delta
	)
	
	var pos = global_position
	
	location_text.text = "Location: X: %d | Y: %d | Z: %d" % [
		roundi(pos.x),
		roundi(pos.y),
		roundi(pos.z)
	]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_build_menu"):
		if placement_manager == null:
			placement_manager = placement_manager_scene.instantiate()
			
			get_tree().current_scene.add_child(placement_manager)
			
			placement_manager.setup($SpringArm3D/cam, self.get_parent_node_3d(), false)
		else:
			placement_manager.queue_free()
			placement_manager = null
	if event.is_action_pressed("destroy_build"):
		if placement_manager == null:
			placement_manager = placement_manager_scene.instantiate()
			
			get_tree().current_scene.add_child(placement_manager)
			
			placement_manager.setup($SpringArm3D/cam, self.get_parent_node_3d(), true)
		else:
			placement_manager.queue_free()
			placement_manager = null
	
	if event.is_action_pressed("open_resources"):
		if resources_panel == null:
			resources_panel = resources_panel_scene.instantiate()
			
			get_tree().current_scene.add_child(resources_panel)
		else:
			resources_panel.queue_free()
			resources_panel = null
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			rotating = event.pressed
			
		if event.button_index == MOUSE_BUTTON_LEFT:
			panning = event.pressed
			
		# Zoom in
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			spring_arm.spring_length = max(
				5.0, 
				spring_arm.spring_length - zoom_speed
			)
		
		# Zoom Out
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			spring_arm.spring_length = min(
				80.0,
				spring_arm.spring_length + zoom_speed
			)
	
	# Mouse Movement
	if event is InputEventMouseMotion:
		if rotating: 
			rotation.y -= event.relative.x * orbit_sensitivity
			spring_arm.rotation.x -= event.relative.y * orbit_sensitivity
			spring_arm.rotation.x = clamp(
				spring_arm.rotation.x,
				deg_to_rad(-80),
				deg_to_rad(-15)
			) 
			
		if panning:
			var right = global_transform.basis.x
			var forward = global_transform.basis.z
			
			right.y = 0
			forward.y = 0
			
			right = right.normalized()
			forward = forward.normalized()
			
			global_position += right * -event.relative.x * pan_sensitivity
			global_position += forward * -event.relative.y * pan_sensitivity
