tool
extends Button
signal selectedIndex
var name_mesh : String = ""
var idx : int = 0
var mesh_node = null
var texture_preview = null

func _ready():
	text = name_mesh
	icon = texture_preview

func _on_btn_mesh_pressed():
	emit_signal("selectedIndex",self,mesh_node,name_mesh)
