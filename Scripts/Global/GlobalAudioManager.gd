extends Node

const defaultPos = Vector2(640,540)
const audioManagerLoad = preload("res://Scenes/AudioManager.tscn")
var audioManager

func _ready():
	audioManager = audioManagerLoad.instance()
	add_child(audioManager)
	audioManager.set_pos(defaultPos)

func get_instance():
	return audioManager