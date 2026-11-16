extends StaticBody3D

var change: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var model = load("res://assets/models/scuffed_drill.glb").instantiate()
	var mesh = model.get_child(0) as MeshInstance3D
	$MeshInstance3D.mesh = mesh.mesh
	self.scale = Vector3(0.25, 0.25, 0.25)
	
	GameManager.samples[GameManager.INCOMING] += 3
	GameManager.energy[GameManager.USE_PER_HOUR] += 5
	
	change = min(GameManager.unused_crew_count, 1)
	
	GameManager.unused_crew_count -= change 


func _exit_tree() -> void: 
	GameManager.samples[GameManager.INCOMING] -= 3
	GameManager.energy[GameManager.USE_PER_HOUR] -= 5
	
	GameManager.unused_crew_count += change
