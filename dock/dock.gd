tool
extends Control

signal changeDrawing
signal select_mesh
signal quantity_change
signal range_distance_change
signal yrot_toggle
signal xrot_toggle
signal zrot_toggle
signal min_scale_x
signal max_scale_x
signal min_scale_y
signal max_scale_y
signal min_scale_z
signal max_scale_z
signal rand_scale_x
signal rand_scale_y
signal rand_scale_z

var mesh_array = []
var selected_node = null
var selected_mesh_node = null
var counter_index = 0
var meshInstance = null
var btn_mesh = preload("btn_mesh.tscn")
var clickAdd : bool = false
var clickRem : bool = false
var drawing : bool = false

var quantity = 1
var range_distance = 1

func _ready():
	pass

func _on_Add_mesh_pressed():
	$FileDialog.show()
	
func _on_Remove_mesh_pressed():
	if selected_node != null:
		remove_mesh_to_gui(selected_node)

func SelectIndexUpdate(node_selected,mesh_node_selected,mesh_name):
	selected_node = node_selected
	selected_mesh_node = mesh_node_selected
	emit_signal("select_mesh",selected_mesh_node,mesh_name)

func add_mesh_to_gui(meshGui):
	$TabContainer/resource/VBoxContainer/ScrollContainer/MeshContainer.add_child(meshGui)
	mesh_array.append(meshInstance)
	counter_index+=1
	
func remove_mesh_to_gui(node):
	$TabContainer/resource/VBoxContainer/ScrollContainer/MeshContainer.remove_child(node)
	mesh_array.erase(selected_mesh_node)
	selected_mesh_node = null
	selected_node = null
	counter_index-=1

func _on_FileDialog_file_selected(path):
	meshInstance = load(path)
	var btn_mesh_ins = btn_mesh.instance()
	if meshInstance != null:
		btn_mesh_ins.name_mesh = meshInstance.resource_name
		btn_mesh_ins.idx = counter_index
		btn_mesh_ins.mesh_node = meshInstance
		btn_mesh_ins.connect("selectedIndex",self,"SelectIndexUpdate")
		add_mesh_to_gui(btn_mesh_ins)
		meshInstance = null
	else:
		print("No mesh selected")


func _on_drawing_pressed():
	drawing = !drawing
	emit_signal("changeDrawing",drawing)


func _on_quantity_slider_value_changed(value):
	$TabContainer/brush/vbx/ScrollContainer/VBoxContainer/vslider_container/quantity_lbl.set_text("Quantity: " + str(value))
	quantity = value
	emit_signal("quantity_change",quantity)

func _on_range_slider_value_changed(value):
	$TabContainer/brush/vbx/ScrollContainer/VBoxContainer/vslider_container2/range_lbl.set_text("Range Distance: " + str(value))
	range_distance = value
	emit_signal("range_distance_change",range_distance)


func _on_Yrot_check_toggled(button_pressed):
	emit_signal("yrot_toggle",button_pressed)

func _on_Xrot_check_toggled(button_pressed):
	emit_signal("xrot_toggle",button_pressed)

func _on_Zrot_check_toggled(button_pressed):
	emit_signal("zrot_toggle",button_pressed)

func _on_rand_scale_x_toggled(button_pressed):
	emit_signal("rand_scale_x",button_pressed)

func _on_min_x_text_changed(new_text):
	emit_signal("min_scale_x",float(new_text))
	

func _on_max_x_text_changed(new_text):
	emit_signal("max_scale_x",float(new_text))

func _on_min_y_text_changed(new_text):
	emit_signal("min_scale_y",float(new_text))

func _on_max_y_text_changed(new_text):
	emit_signal("max_scale_y",float(new_text))

func _on_min_z_text_changed(new_text):
	emit_signal("min_scale_z",float(new_text))

func _on_max_z_text_changed(new_text):
	emit_signal("max_scale_z",float(new_text))


func _on_rand_scale_y_toggled(button_pressed):
	emit_signal("rand_scale_y",button_pressed)

func _on_rand_scale_z_toggled(button_pressed):
	emit_signal("rand_scale_z",button_pressed)


func _on_generate_btn_pressed():
	var children = get_tree().edited_scene_root.get_children()
	for i in children.size():
		if children[i] is MultiMeshInstance and children[i].has_method("generate_multimesh"):
			children[i].generate_multimesh()
