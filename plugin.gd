tool
extends EditorPlugin

var dock
var adder

func _enter_tree():
	dock = preload("res://addons/EminMultiMesh/dock/dock.tscn").instance()
	add_custom_type("SpatialAdder","Spatial",preload("res://addons/EminMultiMesh/spatialAdder/spatialAdder.gd"),preload("res://addons/EminMultiMesh/icon/icon.png"))
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UL,dock)
func forward_spatial_gui_input(camera, event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			print("ciao")

func handles(object):
	return object != null and object is dock

func _exit_tree():
	remove_custom_type("SpatialAdder")
	remove_control_from_docks(dock)
	dock.free()
