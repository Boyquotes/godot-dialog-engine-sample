extends Control

onready var Background = get_node("Background")
onready var DialogBox = get_node("DialogBox")
onready var DialogText = get_node("DialogBox/DialogText")
onready var event_queue = []
onready var event_queue_type = []
onready var DialogSpeakSound = get_node("DialogBox/DialogSpeakSound")
onready var SE01 = get_node("SE01")
onready var SE02 = get_node("SE02")
onready var SE03 = get_node("SE03")
onready var SE04 = get_node("SE04")
onready var SE05 = get_node("SE05")
onready var SE06 = get_node("SE06")
onready var SE07 = get_node("SE07")
onready var SE08 = get_node("SE08")
onready var DialogContinueArrow = get_node("DialogBox/DialogContinueArrow")
var gamemode = "title"
var tsl_charprint = 0
var text_speed = .02
var curr_char_index = 0
var tsl_cursorblink = 0
var cursorblink_speed = .5
var progress_dialog_okay = false
var eventover = true
var event = 0
var next_event
var allow_new_click = true

onready var DebugOutput = get_node("Debug/DebugOutput")


func _ready():
	Background.texture = load("res://black_bg.png")
	DialogBox.visible = false
	DialogText.text = ""
	DialogContinueArrow.visible = false
	change_mode_title()	
	clear_text()

func _process(delta):
	if !allow_new_click and Input.is_action_just_released("ui_accept"):
		allow_new_click = true
	if eventover == false:
		if event == 1:
			event0001()			

	if gamemode == "title":
		title_handler(delta)
	if gamemode == "dialog":
		if event_queue.empty() == false:
			dialog_handler(delta)
	
func change_mode_title():
	gamemode = "title"
	Background.texture = load("res://background.png")
	DialogBox.visible = false	

func title_handler(delta):
	if Input.is_action_pressed("ui_accept") and allow_new_click:
		allow_new_click = false
		set_event(1)

func dialog_handler(delta):
	DebugOutput.text = " tsl_charprint = \t" + str(tsl_charprint)
	DebugOutput.text += "\n text_speed = \t" + str(text_speed)
	DebugOutput.text += "\n curr_char_index = \t" + str(curr_char_index)
	DebugOutput.text += "\n DialogText.percent_visible = \t" + str(DialogText.percent_visible)
	
	if DialogText.percent_visible < 1:
		DialogContinueArrow.visible = false
		tsl_charprint += delta
		if Input.is_action_pressed("ui_accept") and allow_new_click:
			allow_new_click = false
			DialogText.percent_visible = 1		
		else: if tsl_charprint > text_speed:
			DialogText.visible_characters += 1
			curr_char_index += 1
			tsl_charprint = 0
	else:
		curr_char_index = 0
		tsl_charprint = 0
		tsl_cursorblink += delta
		if tsl_cursorblink > cursorblink_speed:
			if DialogContinueArrow.visible == false:
				DialogContinueArrow.visible = true
			else:
				DialogContinueArrow.visible = false
			tsl_cursorblink = 0
		if Input.is_action_pressed("ui_accept") and allow_new_click:
			allow_new_click = false
			event_queue_type.pop_front()
			event_queue.pop_front()
			next_dialog()
			clear_text()

func next_dialog():
	if event_queue_type[0] == "dialog":
		DialogText.text = event_queue[0]
	if event_queue_type[0] == "background":
		Background.texture = load(event_queue[0])
		event_queue_type.pop_front()
		event_queue.pop_front()
		next_dialog()
	if event_queue_type[0] == "audio":
		play_audio_internal(event_queue[0])
		event_queue_type.pop_front()
		event_queue.pop_front()
		next_dialog()
	if event_queue_type[0] == "exit":
		get_tree().quit()

func play_audio_internal(sound_info):
	if sound_info[2] == 1:
		SE01.stream = load(sound_info[0])
		SE01.volume_db = sound_info[1]
		SE01.play()		
	if sound_info[2] == 2:
		SE02.stream = load(sound_info[0])
		SE02.volume_db = sound_info[1]
		SE02.play()		
	if sound_info[2] == 3:
		SE03.stream = load(sound_info[0])
		SE03.volume_db = sound_info[1]
		SE03.play()		
	if sound_info[2] == 4:
		SE04.stream = load(sound_info[0])
		SE04.volume_db = sound_info[1]
		SE04.play()		
	if sound_info[2] == 5:
		SE05.stream = load(sound_info[0])
		SE05.volume_db = sound_info[1]
		SE05.play()		
	if sound_info[2] == 6:
		SE06.stream = load(sound_info[0])
		SE06.volume_db = sound_info[1]
		SE06.play()		
	if sound_info[2] == 7:
		SE07.stream = load(sound_info[0])
		SE07.volume_db = sound_info[1]
		SE07.play()		
	if sound_info[2] == 8:
		SE08.stream = load(sound_info[0])
		SE08.volume_db = sound_info[1]
		SE08.play()		
		
func set_event(eventnumber):
	eventover = false
	event = eventnumber

func next_event():
	eventover = false
	event = next_event
	
func clear_text():
	DialogText.percent_visible = 0
	DialogContinueArrow.visible = false	

func dialog(text):
	event_queue_type.push_back("dialog")
	event_queue.push_back(text)
	
func audio(sound_info):
	event_queue_type.push_back("audio")
	event_queue.push_back(sound_info)	
	
func background(filepath):
	event_queue_type.push_back("background")
	event_queue.push_back(filepath)	
	
func exitgame():
	event_queue_type.push_back("exit")
	event_queue_type.push_back("exit")
	
func event0001():
	gamemode = "dialog"	
	DialogBox.visible = true
	
	background("res://bg2.png")
	audio(["res://music.ogg", 0, 1])	
	dialog("Guy1: Check out this dialog man.")
	dialog("Guy2: Man that dialogue is pretty good dialog. I like how the words just sort of... scroll.")
	dialog("Guy1: I know right? And if you hit space, they scroll all the way real quick.")
	dialog("Guy2: ...isn't it easier to just click the mouse button?")		
	dialog("Guy1: But the title screen said push space.")
	audio(["res://clock.wav", 0, 3])
	dialog("Guy2: Come on guy, think outside the box a little. I mean... ... what is... that?")			
	background("res://bg3.png")
	dialog("Guy2: Ohhh man. You hear that clock?")
	dialog("Guy1: It's ticking. You hear that?")	
	dialog("Guy2: Dude I am freaking out right now. How did we get indoors?")	
	dialog("Guy1: Oh no. I feel like everything's about to just... end.")	
	exitgame()
		
	eventover = true
	next_dialog()
	
	
	
	
