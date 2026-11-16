extends Resource
class_name BuildingData

@export_group("UI Info")
@export var building_name: String
@export var building_icon: Texture2D

@export_group("Game Info") 
@export var building_scene: PackedScene
@export var building_description: String
@export var money_cost: int
@export var constructable_cost: int 

@export_group("Placement Info")
@export var placement_shape: Shape3D
@export var placement_offset: Vector3 = Vector3.ZERO
