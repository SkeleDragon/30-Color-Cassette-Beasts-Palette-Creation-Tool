extends BattleSlot

#signal sprite_changed
#signal occupier_changed
#signal mouse_entered
#signal mouse_exited
#signal pressed

#enum Direction{LEFT = - 1, RIGHT = 1}

#export (Direction) var direction = Direction.RIGHT setget set_direction
#export  var team:int = 0
#export (Resource) var named_sounds:Resource
#export (String) var idle_override:String = "" setget set_idle_override
#export (bool) var scissor_enabled:bool = true setget set_scissor_enabled
#export (bool) var status_bubble_enabled:bool = true
#export (bool) var target_button_at_top:bool = false
#export (NodePath) var focus_neighbour_bottom:NodePath
#export (NodePath) var focus_neighbour_left:NodePath
#export (NodePath) var focus_neighbour_right:NodePath
#export (NodePath) var focus_neighbour_top:NodePath

#onready var animation_player:AnimationPlayer = $AnimationPlayer
#onready var sprite_container:Spatial = $SpriteContainer
#onready var decoy_container:Spatial = $DecoyContainer
#onready var audios = [$Audio1, $Audio2, $Audio3]
#onready var voice_player = $Voice
#onready var vcams = $VCams
#onready var static_body = $StaticBody

#var occupier:WeakRef = null setget set_occupier
#var form:BaseForm
#var movement_tween:Tween
#var palette:Array
#var animation_prefix:String = ""
#var animation_prefix_priority:int = 0
#var audio_volume:float = 1.0


#var occupier:WeakRef = null setget set_occupier
#var form:BaseForm
#var movement_tween:Tween
#var palette:Array
#var animation_prefix:String = ""
#var animation_prefix_priority:int = 0
#var audio_volume:float = 1.0

func _ready():
	set_idle_override(idle_override)
	set_scissor_enabled(scissor_enabled)
	decoy_container.idle = "idle"
	movement_tween = Tween.new()
	add_child(movement_tween)
	set_direction(direction)

func has_sprite()->bool:
	return sprite_container.scene != null

func set_occupier(value:WeakRef):
	occupier = value
	emit_signal("occupier_changed")

func get_fighter():
	if occupier == null or occupier.get_ref() == null:
		return null
	return occupier.get_ref().get_fighter()

func set_idle_override(value:String):
	idle_override = value
	if idle_override != "":
		sprite_container.idle = idle_override
		sprite_container.alt_idle = idle_override
	else :
		sprite_container.idle = "idle"
		sprite_container.alt_idle = "alt_idle"

func set_scissor_enabled(value:bool):
	scissor_enabled = value
	if sprite_container:
		sprite_container.scissor_enabled = scissor_enabled

func clear():
	form = null
	sprite_container.set_scene(null)
	decoy_container.set_scene(null)
	sprite_container.set_albedo(Color.white)
	sprite_container.set_wave_amplitude(0.0)
	sprite_container.set_wave_v_frequency(0.0)
	sprite_container.set_static_amount(0.0)
	set_sparkle(false)
	palette = []
	set_idle_override("")
	update_collision()
	emit_signal("sprite_changed")

func update_collision():
	var aabb = get_aabb()


	static_body.scale.y = aabb.size.y

	static_body.transform.origin.y = aabb.position.y + 0.5 * static_body.scale.y
	static_body.rotation_degrees = Vector3( - 14, 0, 0)

func get_target_button_position()->Vector3:
	if target_button_at_top:
		var t = Transform().rotated(Vector3(1, 0, 0), deg2rad( - 14))
		return t.xform(Vector3(0, 10, 0))
	return Vector3(0, 0, 0)

func set_direction(value):
	direction = value
	var pos
	if sprite_container != null:
		pos = sprite_container.translation / scale
	scale.x = abs(scale.x) * direction
	if sprite_container != null:
		sprite_container.translation = pos * scale
		sprite_container.flip_h = value == Direction.LEFT
	if decoy_container != null:
		decoy_container.flip_h = value == Direction.LEFT

func set_form(value:BaseForm, idle_override:String = ""):
	if form != value:
		form = value
		if form == null:
			clear()
		else :
			sprite_container.set_scene(form.battle_sprite_instance())
			sprite_container.set_swap_colors(form.swap_colors)
			sprite_container.set_default_palette(form.default_palette)
			sprite_container.set_emission_palette(form.emission_palette)
			set_palette(palette, false)
			set_sparkle(form.get_sparkle())
			
			decoy_container.translation.x = get_named_position("decoy").x
			update_collision()
			
	if form and form.is_unstable_fusion():
		sprite_container.set_static_amount(0.05)
		sprite_container.set_static_speed( - 0.5)
		sprite_container.set_wave_amplitude(0.005)
		sprite_container.set_wave_t_frequency(10)
		sprite_container.set_wave_v_frequency(10)
	else :
		sprite_container.set_static_amount(0.0)
		sprite_container.set_static_speed(0.0)
		sprite_container.set_wave_amplitude(0.0)
	
	set_idle_override(idle_override)
	if idle_override != "":
		play_sprite_animation(idle_override)
	emit_signal("sprite_changed")

func set_decoy(decoy:PackedScene):
	decoy_container.set_scene(decoy)

func set_palette(value:Array = [], animate:bool = true):
	palette = value
	if animate:
		return sprite_container.tween_palette(palette, 0.3)
	else :
		sprite_container.set_palette(palette)

func set_sparkle(value:bool):
	sprite_container.set_sparkle(value)

func add_animation_prefix(prefix:String, priority:int):
	if priority >= animation_prefix_priority:
		sprite_container.animation_prefix = prefix
		animation_prefix_priority = priority

func remove_animation_prefix(prefix:String):
	if sprite_container.animation_prefix == prefix:
		sprite_container.animation_prefix = ""
		animation_prefix_priority = 0

func _get_free_audio_player():
	for audio in audios:
		if not audio.is_playing():
			return audio
	return audios[0]

func play_sound(stream, pitch_scale:float = 1.0, random_pitch:float = 1.0):
	if stream is Array:
		if stream.size() == 0:
			return Co.pass()
		stream = stream[randi() % stream.size()]
	if stream == null:
		return Co.pass()
	assert (stream is AudioStream)
	var audio = _get_free_audio_player()
	audio.stop()
	if stream == null:
		return Co.pass()
	var aabb = get_aabb()
	audio.translation = aabb.position + aabb.size / 2.0
	audio.stream.audio_stream = stream
	audio.stream.random_pitch = random_pitch
	audio.pitch_scale = pitch_scale
	audio.unit_db = linear2db(audio_volume)
	audio.play()
	return Co.wait_for_audio(audio)

func play_voice(stream):
	if stream is Array:
		if stream.size() == 0:
			return Co.pass()
		stream = stream[randi() % stream.size()]
	voice_player.stop()
	if stream == null:
		return Co.pass()
	var aabb = get_aabb()
	voice_player.translation = aabb.position + aabb.size / 2.0
	voice_player.stream = stream
	voice_player.unit_db = linear2db(audio_volume)
	voice_player.play()

func play_form_sound(name:String, pitch_scale:float = 1.0):
	if not form:
		return Co.pass()
	return play_sound(form.get(name), pitch_scale, 1.1)

func play_form_defeat_cry():
	if not form:
		return 
	if form.defeat_cry != null:
		return play_form_sound("defeat_cry")
	return play_form_sound("battle_cry", 0.667)

func play_named_sound(name:String, pitch_scale:float = 1.0):
	if name == "transform_sound" and not UserSettings.audio_transform:
		return 
	return play_sound(named_sounds.get(name), pitch_scale, 1.1)

func play_animation(anim_name:String, random_position:bool = false):
	return Co.join([
		play_sprite_animation(anim_name, random_position), 
		play_slot_animation(anim_name, random_position)
	])

func play_slot_animation(anim_name:String, random_position:bool = false):
	if not animation_player.has_animation(anim_name):
		return Co.pass()
	var anim = animation_player.get_animation(anim_name)
	anim.loop = false
	animation_player.play(anim_name)
	if random_position:
		animation_player.seek(randf() * anim.length, true)
	else :
		animation_player.advance(0.0)
	yield (animation_player, "animation_finished")

func play_sprite_animation(anim_name:String, random_position:bool = false):
	return sprite_container.play_animation(anim_name, random_position)

func play_decoy_animation(anim_name:String, backwards:bool = false):
	return decoy_container.play_animation(anim_name, false, backwards)

func wait_for_idle_sync():
	return sprite_container.wait_for_idle_sync()

func transform_to(form:BaseForm, palette:Array = [], sparkle = null, idle_override:String = ""):
	sprite_container.push_params()
	if self.form != null:
		yield (play_slot_animation("transform_out"), "completed")
	sprite_container.pop_params()
	set_form(form, idle_override)
	set_palette(palette, false)
	if sparkle != null:
		set_sparkle(sparkle)
	sprite_container.push_params()
	if form != null:
		yield (play_slot_animation("transform_in"), "completed")
	sprite_container.pop_params()

func get_aabb()->AABB:
	return sprite_container.get_aabb()

func get_selection_aabb()->AABB:
	var aabb = AABB(Vector3(), Vector3())
	aabb = aabb.expand(get_named_position("decoy"))
	aabb = aabb.expand(get_named_position("decoy") * Vector3( - 1, 1, 1))
	aabb = aabb.expand(sprite_container.get_aabb().end * Vector3(0, 1, 0))
	return aabb

func move_to(target_pos:Vector3, immediate:bool = false, duration:float = 0.3, trans_type = Tween.TRANS_CUBIC, ease_type = Tween.EASE_IN_OUT):
	
	var target_translation = global_transform.xform_inv(target_pos)
	
	
	target_translation /= scale.abs() * scale.abs()
	
	
	
	if immediate:
		sprite_container.translation = target_translation
	else :
		movement_tween.stop_all()
		movement_tween.remove_all()
		movement_tween.interpolate_property(sprite_container, "translation", null, target_translation, duration, trans_type, ease_type)
		movement_tween.start()
		yield (Co.wait_for_tween(movement_tween), "completed")

func reset_position(immediate:bool = false):
	return move_to(global_transform.origin, immediate)

func is_moved()->bool:
	return sprite_container.translation.length_squared() >= 0.125

func move_to_melee_targets(targets:Array, offset:Vector3 = Vector3()):
	if targets.size() == 0:
		return Co.pass()
	
	var origin = global_transform.xform(get_named_position("attack"))
	origin.y = global_transform.origin.y
	
	var distance = 0.0
	var heading = Vector3()
	for target in targets:
		var pos = target.global_transform.xform(target.get_named_position("melee_range"))
		distance += origin.distance_to(pos)
		heading += (pos - origin).normalized()
	if targets.size() > 0:
		heading = heading.normalized()
		distance /= targets.size()
	
	if heading.x * scale.x < 0.0:
		
		return move_to(global_transform.origin)
	
	var target_pos:Vector3
	if targets.size() == 1:
		target_pos = targets[0].global_transform.xform(targets[0].get_named_position("melee_range"))
		target_pos.x -= (origin - global_transform.origin).x
		target_pos.y = 0.0
		target_pos.z = targets[0].global_transform.origin.z + 0.125
	else :
		target_pos = heading * distance + global_transform.origin + offset
	
	return move_to(target_pos)

func _get_named_position(name:String):
	if form != null and form.named_positions.has(name):
		var named_pos = form.named_positions[name]
		return sprite_container.transform.xform(sprite_container.get_position(named_pos))
	return null

func get_named_position(name:String)->Vector3:
	
	var named_pos = _get_named_position(name)
	if name == "origin":
		return sprite_container.transform.origin
	
	if name == "center":
		var pos = _get_named_position("hit")
		pos.x = sprite_container.transform.origin.x
		return pos
	
	if name == "decoy" or name == "decoy_toast":
		var pos = decoy_container.transform.xform(decoy_container.get_center())
		if named_pos != null:
			pos.x = named_pos.x
		else :
			pos.x = sprite_container.get_aabb().end.x
		if name == "decoy_toast":
			pos.y = decoy_container.transform.xform(decoy_container.get_aabb().end).y
		return pos
	
	if name == "melee_range":
		if named_pos == null:
			return Vector3(get_named_position("decoy").x, 0.0, 0.0)
		return Vector3(named_pos.x, 0.0, 0.0)
	
	if name == "super_attack" and named_pos == null:
		named_pos = _get_named_position("attack")
	
	if name == "toast" and named_pos == null:
		named_pos = _get_named_position("hit")
		if named_pos == null:
			named_pos = sprite_container.transform.origin
		named_pos.y = sprite_container.transform.xform(sprite_container.get_aabb().end).y
		
	if named_pos != null:
		return named_pos
		
	return sprite_container.transform.origin

func is_idle()->bool:
	return not animation_player.is_playing() and sprite_container.is_idle()

func get_vcam(name:String)->VirtualCamera:
	if vcams.has_node(name):
		return vcams.get_node(name)
	return vcams.get_node(NodePath("default"))

func vibrate(magnitude:float, duration:float):
	if team == 0:
		MultiplayerInput.start_joy_vibration( - 1, magnitude, duration)

func _on_StaticBody_mouse_entered():
	emit_signal("mouse_entered")

func _on_StaticBody_mouse_exited():
	emit_signal("mouse_exited")

func _on_StaticBody_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		emit_signal("pressed")
		get_tree().set_input_as_handled()
