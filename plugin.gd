tool
extends EditorPlugin
var dock = preload("res://addons/EminMultiMesh/dock/dock.tscn")
var dock_ins = null
var adder_script = preload("res://addons/EminMultiMesh/MultiMeshEmin.gd")

var positionArray = []

var drawing : bool = false

func _enter_tree():
	dock_ins = dock.instance()
	dock_ins.connect("changeDrawing",self,"enable_drawing")
	add_custom_type("MultiMeshEmin","MultiMeshInstance",adder_script,preload("res://addons/EminMultiMesh/icon/icon.png"))
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT,dock_ins)

func forward_spatial_gui_input(camera, event):
	if event is InputEventMouseButton and drawing:
		if event.is_pressed() and event.button_index == BUTTON_LEFT and !event.is_echo():
			var from = camera.project_ray_origin(event.position)
			var to = from + camera.project_ray_normal(event.position) * 1000
			
			var space_state = get_viewport().world.direct_space_state
			var result = space_state.intersect_ray(from,to)
			if result.has("position"):
				positionArray.append(result.position)
			print(result.position)

func enable_drawing(value):
	drawing = value

func handles(object):
	return object

func _exit_tree():
	remove_custom_type("MultiMeshEmin")
	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT,dock_ins)
	dock_ins.free()
