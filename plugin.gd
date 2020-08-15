tool
extends EditorPlugin

var dock = preload("res://addons/EminMultiMesh/dock/dock.tscn")
var dock_ins = null
var multimeshnode = preload("res://addons/EminMultiMesh/multimeshnode/MultiMeshEmin.tscn")
var node_s = null

var mesh_selected : Mesh = null
var mesh_name : String = ""
var multimesh_array = []
var drawing : bool = false

func _enter_tree():
	dock_ins = dock.instance()
	dock_ins.connect("changeDrawing",self,"enable_drawing")
	dock_ins.connect("select_mesh",self,"mesh_selected")
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT,dock_ins)

func mesh_selected(mesh_ins,_mesh_name):
	mesh_selected = mesh_ins
	mesh_name = _mesh_name

func forward_spatial_gui_input(camera, event):
	var cur_editor_scene = get_tree().edited_scene_root
	if event is InputEventMouseButton and drawing:
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 1000
		if event.is_pressed() and event.button_index == BUTTON_LEFT and !event.is_echo():
			var space_state = get_viewport().world.direct_space_state
			var result = space_state.intersect_ray(from,to)
			if result.has("position"):
				var multimi = multimeshnode.instance()
				var test : MeshInstance = MeshInstance.new()
				test.mesh = mesh_selected
				test.transform.origin = result.position
				test.name = mesh_name
				if !cur_editor_scene.has_node(multimi.get_path()):
					multimi.transform.origin = Vector3(0,0,0)
					multimi.name = "MultiMeshEmin"
					cur_editor_scene.add_child(multimi)
					multimi.set_owner(cur_editor_scene)
				else:
					multimi = cur_editor_scene.get_node(multimi.get_path())
				
				multimi.add_child(test)
				test.set_owner(cur_editor_scene)
				
		elif event.is_pressed() and event.button_index == BUTTON_RIGHT and !event.is_echo():
			var hits = VisualServer.instances_cull_ray(from,to,node_s.get_world().scenario)
			pass

func enable_drawing(value):
	drawing = value

func edit(object):
	node_s = object
	if node_s:
		set_physics_process(true)
	else:
		set_physics_process(false)
	return object

func handles(object):
	return object

func _exit_tree():
	remove_custom_type("MultiMeshEmin")
	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT,dock_ins)
	dock_ins.free()
