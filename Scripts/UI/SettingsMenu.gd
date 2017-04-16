extends Control

# TODO: 
# Add more resolutions (look at steam's HW stats)
# Bring up saved settings

const volScaleDiv = 100
const defaultRes = Vector2(1280,720)
const screenOffset = Vector2(100,100)
const onText = "ON"
const offText = "OFF"
const resolutions = {"2560x1600":Vector2(2560,1600), "2560x1440":Vector2(2560,1440), "1920x1200":Vector2(1920,1200), 
					"1920x1080":Vector2(1920,1080), "1280x800":Vector2(1280,800), "1366x768":Vector2(1366,768), 
					"1280x720":Vector2(1280,720), "640x360":Vector2(640,360)}
					
var availableResolutions
var settingsMenuPanel
var resolutionButton
var fullscreenButton
var currScreen
var currScreenRes

var audioManager
var masterVolumeSlider
var fxVolumeSlider
var bgmVolumeSlider
var ambientVolumeSlider

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	masterVolumeSlider = get_node("SettingsMenuPanel/ScrollContainer/VBoxContainer/MasterVolumeSlider")
	settingsMenuPanel = get_node("SettingsMenuPanel")
	resolutionButton = get_node("SettingsMenuPanel/ScrollContainer/VBoxContainer/ResolutionButton")
	fullscreenButton = get_node("SettingsMenuPanel/ScrollContainer/VBoxContainer/FullscreenButton")
	masterVolumeSlider = get_node("SettingsMenuPanel/ScrollContainer/VBoxContainer/MasterVolumeSlider")
	fxVolumeSlider = get_node("SettingsMenuPanel/ScrollContainer/VBoxContainer/FxVolumeSlider")
	bgmVolumeSlider = get_node("SettingsMenuPanel/ScrollContainer/VBoxContainer/BgmVolumeSlider")
	ambientVolumeSlider = get_node("SettingsMenuPanel/ScrollContainer/VBoxContainer/AmbientVolumeSlider")
	
	resolutionButton.connect("item_selected", self, "on_resolution_selected")
	fullscreenButton.connect("pressed", self, "on_fullscreen_selected")
	masterVolumeSlider.connect("value_changed", self, "on_master_volume_adjust")
	fxVolumeSlider.connect("value_changed", self, "on_fx_volume_adjust")
	bgmVolumeSlider.connect("value_changed", self, "on_bgm_volume_adjust")
	ambientVolumeSlider.connect("value_changed", self, "on_ambient_volume_adjust")
	
	setup_display()
	setup_audio()

func setup_display():
	var projectResolution = Vector2(Globals.get("display/width"),Globals.get("display/height")) 
	availableResolutions = []
	currScreen = OS.get_current_screen()
	currScreenRes = OS.get_screen_size(currScreen)
	
	add_items_to_dropdown()
	fullscreen_toggle(false, defaultRes)
	resolutionButton.set_text_align(1) #0 is LEFT, 1 is CENTER, 2 is RIGHT
	resolutionButton.select(availableResolutions.find(defaultRes))
	resolutionButton.grab_focus()
	settingsMenuPanel.set_pos(Vector2(projectResolution.x/3, projectResolution.y/3)) #set pos related to project res
	settingsMenuPanel.show()

func setup_audio():
	audioManager = GlobalAudioManager.get_instance()
	var masterVol = masterVolumeSlider.get_value()
	var fxVol = masterVol * fxVolumeSlider.get_value() / volScaleDiv 
	var bgmVol = masterVol * bgmVolumeSlider.get_value() / volScaleDiv
	var ambientVol = masterVol * ambientVolumeSlider.get_value() / volScaleDiv
	audioManager.set_bgm_volume(bgmVol)
	audioManager.set_ambient_volume(ambientVol)
	audioManager.set_fx_volume(fxVol)
	
#adds resolutions to dropdown
func add_items_to_dropdown():
	var highestRes = currScreenRes
	for key in resolutions.keys():
		var val = resolutions[key]
		if(highestRes.y >= val.y):
			resolutionButton.add_item(key)
			availableResolutions.append(val)
			print("Available Resolutions : " + str(key)+' ' +str(availableResolutions[availableResolutions.size()-1]))
		
#when selecting resolution, switch to resolution
func on_resolution_selected(id):
	var targetRes = availableResolutions[id]
	if(targetRes>= currScreenRes):
		var toggle = OS.is_window_fullscreen()
		fullscreen_toggle(toggle, targetRes)
	else:
		var toggle = false
		fullscreen_toggle(toggle, targetRes)
	resolutionButton.select(id)

#toggle fullscreen
func on_fullscreen_selected():
	var toggle = !OS.is_window_fullscreen()
	var targetRes = OS.get_window_size()
	fullscreen_toggle(toggle, targetRes)

#toggles fullscreen to true/false
func fullscreen_toggle(toggleValue, targetRes):
	if(toggleValue):
		OS.set_window_maximized(toggleValue)
		OS.set_window_fullscreen(toggleValue)
	else:
		OS.set_window_maximized(toggleValue)
		OS.set_window_fullscreen(toggleValue)
		OS.set_window_size(targetRes)
		OS.set_window_position(screenOffset)
	resolutionButton.select(availableResolutions.find(currScreenRes))
	fullscreen_text_toggle()

#toggles fullscreen text on/off
func fullscreen_text_toggle():
	if(OS.is_window_fullscreen()):
		fullscreenButton.set_text(onText)
	else:
		fullscreenButton.set_text(offText)
		
func on_master_volume_adjust(value):
	var vol = value/volScaleDiv
	audioManager.set_fx_volume(vol* fxVolumeSlider.get_value())
	audioManager.set_bgm_volume(vol * bgmVolumeSlider.get_value())
	audioManager.set_ambient_volume(vol * ambientVolumeSlider.get_value())
	
func on_fx_volume_adjust(value):
	var vol = value/volScaleDiv
	audioManager.set_fx_volume(vol* fxVolumeSlider.get_value())
	
func on_bgm_volume_adjust(value):
	var vol = value/volScaleDiv
	audioManager.set_bgm_volume(vol * masterVolumeSlider.get_value())

func on_ambient_volume_adjust(value):
	var vol = value/volScaleDiv
	audioManager.set_ambient_volume(vol * masterVolumeSlider.get_value())
	

