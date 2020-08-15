tool
extends MultiMeshInstance
export (bool) var generate = false setget generate_multimesh
func _ready():
	var mm = MultiMesh.new()
	mm.color_format = MultiMesh.COLOR_FLOAT
	mm.transform_format = MultiMesh.TRANSFORM_3D
	multimesh = mm

func generate_multimesh(value):
	if value == true:
		multimesh.instance_count = get_child_count()
		multimesh.mesh = get_children()[0].mesh
		for i in multimesh.instance_count:
			var origin = get_children()[i].transform.origin
			get_children()[i].queue_free()
			print(origin)
			multimesh.set_instance_transform(i,Transform(Basis(),origin))
