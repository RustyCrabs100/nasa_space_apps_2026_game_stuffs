extends StaticBody3D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var model = load("res://assets/models/small_crew_cabin.glb").instantiate()
	var mesh = model.get_child(0) as MeshInstance3D
	$MeshInstance3D.mesh = mesh.mesh
	
	GameManager.energy[GameManager.USE_PER_HOUR] += 1
	GameManager.oxygen[GameManager.USE_PER_HOUR] += 30
	GameManager.unhoused_crew_count -= 2


func _exit_tree() -> void: 
	GameManager.oxygen[GameManager.USE_PER_HOUR] -= 30
	GameManager.energy[GameManager.USE_PER_HOUR] -= 1
	GameManager.unhoused_crew_count += 2
