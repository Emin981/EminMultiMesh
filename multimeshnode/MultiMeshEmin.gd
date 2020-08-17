tool
extends MultiMeshInstance

func _ready():
	var mm = MultiMesh.new()
	mm.color_format = MultiMesh.COLOR_FLOAT
	mm.transform_format = MultiMesh.TRANSFORM_3D
	multimesh = mm

func generate_multimesh():
	multimesh.instance_count = get_child_count()
	multimesh.mesh = get_children()[0].mesh
	for i in multimesh.instance_count:
		var transf = get_children()[i].transform
		get_children()[i].queue_free()
		multimesh.set_instance_transform(i,transf)
