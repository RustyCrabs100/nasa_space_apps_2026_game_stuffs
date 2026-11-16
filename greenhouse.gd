extends StaticBody3D

var change

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var model = load("res://assets/models/greenhouse.glb").instantiate()
	var mesh = model.get_child(0) as MeshInstance3D
	$MeshInstance3D.mesh = mesh.mesh
	
	GameManager.oxygen[GameManager.INCOMING] += 20.0
	GameManager.water[GameManager.USE_PER_HOUR] += 4.0
	GameManager.energy[GameManager.USE_PER_HOUR] += 2.0
	
	change = min(GameManager.unused_crew_count, 2)
	
	GameManager.unused_crew_count -= change

func _exit_tree() -> void:
	GameManager.oxygen[GameManager.INCOMING] -= 20.0
	GameManager.water[GameManager.USE_PER_HOUR] -= 4.0
	GameManager.energy[GameManager.USE_PER_HOUR] -= 2.0
	
	GameManager.unused_crew_count += change
