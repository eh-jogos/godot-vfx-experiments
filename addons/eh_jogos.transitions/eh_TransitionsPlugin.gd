tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("eh_Transitions", "res://addons/eh_jogos.transitions/eh_Transitions.tscn")


func _exit_tree():
	remove_autoload_singleton("eh_Transitions")
