tool
extends EditorPlugin

var dock = preload("dock/dock.tscn")
var dock_ins = null
var multimeshnode = preload("multimeshnode/MultiMeshEmin.tscn")
var node_s = null

var mesh_selected : Mesh = null
var mesh_name : String = ""
var multimesh_array = []
var drawing : bool = false

var quantity = 1
var range_distance = 1
var rand_scale_x : bool = false
var rand_scale_y : bool = false
var rand_scale_z : bool = false
var rand_x : bool = false
var rand_y : bool = false
var rand_z : bool = false
var min_rand_scale_x : float = 1.0
var min_rand_scale_y : float = 1.0
var min_rand_scale_z : float = 1.0
var max_rand_scale_x : float = 1.0
var max_rand_scale_y : float = 1.0
var max_rand_scale_z : float = 1.0
var collision : bool = false

func _enter_tree():
	dock_ins = dock.instance()
	dock_ins.connect("changeDrawing",self,"enable_drawing")
	dock_ins.connect("select_mesh",self,"mesh_selected")
	dock_ins.connect("quantity_change",self,"quantity_changed")
	dock_ins.connect("range_distance_change",self,"distance_changed")
	dock_ins.connect("yrot_toggle",self,"y_rot_toggle")
	dock_ins.connect("xrot_toggle",self,"x_rot_toggle")
	dock_ins.connect("zrot_toggle",self,"z_rot_toggle")
	dock_ins.connect("rand_scale_x",self,"rand_scale_x_change")
	dock_ins.connect("rand_scale_y",self,"rand_scale_y_change")
	dock_ins.connect("rand_scale_z",self,"rand_scale_z_change")
	dock_ins.connect("min_scale_x",self,"min_scale_x_change")
	dock_ins.connect("min_scale_y",self,"min_scale_y_change")
	dock_ins.connect("min_scale_z",self,"min_scale_z_change")
	dock_ins.connect("max_scale_x",self,"max_scale_x_change")
	dock_ins.connect("max_scale_y",self,"max_scale_y_change")
	dock_ins.connect("max_scale_z",self,"max_scale_z_change")
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT,dock_ins)

func rand_scale_x_change(value):
	rand_scale_x = value
func rand_scale_y_change(value):
	rand_scale_y = value
func rand_scale_z_change(value):
	rand_scale_z = value
func min_scale_x_change(value):
	min_rand_scale_x = value
func min_scale_y_change(value):
	min_rand_scale_y = value
func min_scale_z_change(value):
	min_rand_scale_z = value
func max_scale_x_change(value):
	max_rand_scale_x = value
func max_scale_y_change(value):
	max_rand_scale_y = value
func max_scale_z_change(value):
	max_rand_scale_z = value


func y_rot_toggle(toggled):
	rand_y = toggled

func x_rot_toggle(toggled):
	rand_x = toggled

func z_rot_toggle(toggled):
	rand_x = toggled

func distance_changed(dis):
	range_distance = dis

func quantity_changed(qt):
	quantity = qt

func mesh_selected(mesh_ins,_mesh_name):
	mesh_selected = mesh_ins
	mesh_name = _mesh_name

func forward_spatial_gui_input(camera, event):
	var cur_editor_scene = get_tree().edited_scene_root
	var captured_event : bool = false
	if event is InputEventMouseButton and drawing:
		if event.is_pressed() and event.button_index == BUTTON_LEFT and !event.is_echo():
			captured_event = true
			var space_state = get_viewport().world.direct_space_state
			var multimi = multimeshnode.instance()
			var mm = MultiMesh.new()
			mm.color_format = MultiMesh.COLOR_FLOAT
			mm.transform_format = MultiMesh.TRANSFORM_3D
			multimi.multimesh = mm
			for i in quantity:
#				(i+rand_range(0,1))*2*PI/quantity
				var offset_brush = Vector3(range_distance*cos(rand_range(0,1)*2*PI),0,range_distance*sin(rand_range(0,1)*2*PI))
				var from = camera.project_ray_origin(event.position)
				var to = from + offset_brush + camera.project_ray_normal(event.position) * 1000
				var result = space_state.intersect_ray(from,to)
				var test : MeshInstance = MeshInstance.new()
				test.mesh = mesh_selected
				if result.has("position"):
					var transf = Transform(Basis(),Vector3(0,0,0))
					if rand_scale_x:
						transf = transf.scaled(Vector3(rand_range(min_rand_scale_x,max_rand_scale_x),1,1))
					if rand_scale_y:
						transf = transf.scaled(Vector3(1,rand_range(min_rand_scale_y,max_rand_scale_y),1))
					if rand_scale_z:
						transf = transf.scaled(Vector3(1,1,rand_range(min_rand_scale_z,max_rand_scale_z)))
					if rand_x:
						transf = transf.rotated(Vector3(1,0,0),deg2rad(rand_range(0,360)))
					if rand_y:
						transf = transf.rotated(Vector3(0,1,0),deg2rad(rand_range(0,360)))
					if rand_z:
						transf = transf.rotated(Vector3(0,0,1),deg2rad(rand_range(0,360))) 
					test.transform = transf
					test.transform.origin = result.position
					test.name = mesh_name
					if !cur_editor_scene.has_node(mesh_name):
						
						multimi.transform.origin = Vector3(0,0,0)
						multimi.name = mesh_name
						cur_editor_scene.add_child(multimi)
						multimi.set_owner(cur_editor_scene)
					else:
						multimi = cur_editor_scene.get_node(mesh_name)
					multimi.add_child(test)
					test.set_owner(cur_editor_scene)
	return captured_event

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
	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT,dock_ins)
	dock_ins.free()
