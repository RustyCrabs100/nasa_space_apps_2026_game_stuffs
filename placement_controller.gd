
extends Node3D

var camera: Camera3D
var buildings_container: Node3D

var selected_building: BuildingData
var preview: Node3D

var can_place := false
var current_position := Vector3.ZERO
var last_preview_valid := false


func setup(cam: Camera3D, buildings: Node3D) -> void:
	camera = cam
	buildings_container = buildings


func start_placement(building: BuildingData) -> void:

	if preview != null:
		preview.queue_free()

	selected_building = building

	preview = building.building_scene.instantiate()
	add_child(preview)

	disable_preview_collision(preview)


func disable_preview_collision(node: Node) -> void:

	if node is CollisionObject3D:
		node.collision_layer = 0
		node.collision_mask = 0

	for child in node.get_children():
		disable_preview_collision(child)


func _process(_delta: float) -> void:

	if preview == null:
		return

	var ground_position = get_mouse_ground_position()

	if ground_position == Vector3.INF:
		can_place = false
		return

	current_position = ground_position
	preview.global_position = current_position

	can_place = check_placement(current_position)

	if can_place != last_preview_valid:
		update_preview_color()
		last_preview_valid = can_place


func get_mouse_ground_position() -> Vector3:

	var mouse = get_viewport().get_mouse_position()

	var origin = camera.project_ray_origin(mouse)
	var direction = camera.project_ray_normal(mouse)

	var query = PhysicsRayQueryParameters3D.create(
		origin,
		origin + direction * 1000.0
	)

	query.collision_mask = 1

	var result = get_world_3d().direct_space_state.intersect_ray(query)

	if result:
		return result.position

	return Vector3.INF


func check_placement(pos: Vector3) -> bool:

	if selected_building.placement_shape == null:
		return false

	var query = PhysicsShapeQueryParameters3D.new()

	query.shape = selected_building.placement_shape

	var basis = preview.global_basis

	var shape_position = pos + basis * selected_building.placement_offset

	query.transform = Transform3D(basis, shape_position)

	query.collision_mask = 2

	var results = get_world_3d().direct_space_state.intersect_shape(query, 32)

	return results.is_empty()


func update_preview_color() -> void:

	var color = Color.GREEN if can_place else Color.RED

	set_preview_material(preview, color)


func set_preview_material(node: Node, color: Color) -> void:

	if node is MeshInstance3D:

		var material = StandardMaterial3D.new()
		material.albedo_color = Color(color.r, color.g, color.b, 0.5)
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA

		node.material_override = material

	for child in node.get_children():
		set_preview_material(child, color)


func _input(event: InputEvent) -> void:

	if preview == null:
		return

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if can_place:
				place_building()

		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			cancel_placement()

	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			cancel_placement()


func place_building() -> void:

	if not can_place:
		return

	if GameManager.funds["amount"] < selected_building.money_cost:
		return

	if GameManager.constructables["amount"] < selected_building.constructable_cost:
		return

	var building = selected_building.building_scene.instantiate()

	buildings_container.add_child(building)

	building.global_transform = preview.global_transform

	GameManager.funds["amount"] -= selected_building.money_cost
	GameManager.constructables["amount"] -= selected_building.constructable_cost

	print("Placed: ", selected_building.building_name)

	queue_free()


func cancel_placement() -> void:
	queue_free()
