extends StaticBody3D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var model = load("res://assets/models/storage_silo.glb").instantiate()
	var mesh = model.get_child(0) as MeshInstance3D
	$MeshInstance3D.mesh = mesh.mesh
	
	GameManager.energy[GameManager.USE_PER_HOUR] += 1


func _exit_tree() -> void: 
	GameManager.energy[GameManager.USE_PER_HOUR] -= 1
