extends Control

var soundtrack
var fxPlayer
var bgmPlayer
var ambientPlayer
var bgm
var ambient

var testFxButton
var testBgmButton
var testAmbientButton
var testAmb = "Sounds/city_rain_roof.ogg"  #sound streams require filepaths
var testBgm = "Sounds/bgm_1.ogg"
var testFx = "sample chord 04" #fx samples are added to library

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	fxPlayer = get_node("FxPlayer")
	bgmPlayer = get_node("BgmPlayer")
	ambientPlayer = get_node("AmbientPlayer")
	testFxButton = get_node("fxButton")
	testBgmButton = get_node("bgmButton")
	testAmbientButton = get_node("ambientButton")
	testFxButton.connect("pressed", self, "on_fx_pressed")
	testBgmButton.connect("pressed", self, "on_bgm_pressed")
	testAmbientButton.connect("pressed", self, "on_ambient_pressed")
	soundtrack = {}
	ambient = load(testAmb)
	bgm = load(testBgm)
	
func on_fx_pressed():
	play_fx(testFx,false)
	
func on_bgm_pressed():
	play_bgm(bgm)
	
func on_ambient_pressed():
	play_ambient(ambient)
	
func set_fx_volume(value):
	AudioServer.set_fx_global_volume_scale(value)
	
func set_bgm_volume(value):
	bgmPlayer.set_volume(value)

func set_ambient_volume(value):
	ambientPlayer.set_volume(value)
	
func play_fx(soundpath, unique):
	fxPlayer.play(soundpath, unique)
	
func play_bgm(soundstream):
	bgmPlayer.set_stream(soundstream)
	bgmPlayer.play()
	
func play_ambient(soundstream):
	ambientPlayer.set_stream(soundstream)
	ambientPlayer.play()
