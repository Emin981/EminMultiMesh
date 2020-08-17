tool
extends MultiMeshInstance

export var collision : bool = false

func _ready():
	if collision:
		generate_collider()

func generate_multimesh():
	multimesh.instance_count = get_child_count()
	multimesh.mesh = get_children()[0].mesh
	for i in multimesh.instance_count:
		var transf = get_children()[i].transform
		get_children()[i].queue_free()
		multimesh.set_instance_transform(i,transf)

func generate_collider():
	for i in self.multimesh.instance_count:
		print("test")
		var shape = multimesh.mesh.create_trimesh_shape()
		var collisionShape = CollisionShape.new()
		var posTrans = Transform().translated(multimesh.get_instance_transform(i).origin)
		collisionShape.shape = shape
		var collisionNode = StaticBody.new()
		collisionNode.transform = posTrans
		collisionNode.add_child(collisionShape)
		add_child(collisionNode)
