
extends CanvasLayer

const RESOURCE_ROW = preload("res://scenes/resource_row.tscn")

@onready var resource_list = get_node_or_null("Mainpanel/MarginContainer/VBoxContainer/ScrollContainer/ResourceList")

var resource_rows: Dictionary = {}


func _ready() -> void:
	generate_resource_rows()
	update_all_resources()


func generate_resource_rows() -> void:
	
	print("Generating Resource Rows...")

	# Discover all resource dictionaries in GameManager
	for property in GameManager.get_property_list():

		var resource_name: String = property["name"]

		# Only inspect dictionaries
		var resource = GameManager.get(resource_name)
		
		print("Checking Property: ", resource_name)

		if typeof(resource) != TYPE_DICTIONARY:
			continue

		# Only treat dictionaries with an amount field as resources
		if not resource.has("amount"):
			continue

		print("Resource Name Passed! ", resource_name)

		var row = RESOURCE_ROW.instantiate()

		resource_list.add_child(row)

		resource_rows[resource_name] = row
	
	await get_tree().process_frame

	print("ResourceList size: ", resource_list.size)
	print("ResourceList visible: ", resource_list.is_visible_in_tree())

	for row in resource_list.get_children():
		print(row.name, " | Size: ", row.size, " | Visible: ", row.visible)
		
	print("Total Rows Made: ", resource_rows.size())
	print("ResourceList Children: ", resource_list.get_child_count())


func update_all_resources() -> void:

	for resource_name in resource_rows:

		var resource = GameManager.get(resource_name)

		if resource == null:
			continue

		var row = resource_rows[resource_name]

		row.update_display(
			resource_name.capitalize().replace("_", " "),
			resource
		)


func _process(_delta: float) -> void:
	update_all_resources()
