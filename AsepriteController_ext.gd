tool 
extends Node

const TRANSPARENT_RENDER_PRIORITY:int = 22

const SpriteShader = preload("res://tools/palette_extender_30/sprite_ext.shader")
const SpriteShaderUnshaded = preload("res://tools/palette_extender_30/sprite_unshaded_ext.shader")
const RenderThroughShader = preload("res://tools/palette_extender_30/render_through_ext.shader")
const RenderThroughShaderUnshaded = preload("res://tools/palette_extender_30/render_through_unshaded_ext.shader")
const ScissorShader = preload("res://tools/palette_extender_30/alpha_scissor_ext.shader")
const ScissorShaderUnshaded = preload("res://tools/palette_extender_30/alpha_scissor_unshaded_ext.shader")
const NumSwapColors = 30
const NumEmissionColors = 10

var scene:Node
var idle:String = "" setget set_idle
var alt_idle:String = "" setget set_alt_idle
var animation_prefix:String = "" setget set_animation_prefix
var direction:String = "none" setget set_direction
var unshaded:bool = false
var scissor_enabled:bool = true
var animation_speed:float = 1.0
var render_priority:int = 0

var sprite:Sprite3D
var material:ShaderMaterial


var material2:ShaderMaterial
var materials:Array = []

var animator:AnimationPlayer = null
var swap_colors:Array = []
var palette:Array = []
var default_palette:Array = []
var emission_palette:Array = []
var tween:Tween
var albedo:Color = Color.white
var render_through:bool = false
var custom_shader:bool = false
var sprite_offset:Vector2
var originally_flipped:bool = false

func _init(scene:Node):
	self.scene = scene
	
	sprite = scene.get_node(NodePath("Sprite3D"))
	sprite_offset = sprite.offset
	custom_shader = sprite.material_override is ShaderMaterial
	material = fix_material(sprite.material_override)
	material2 = fix_material(sprite.material_override)
	material2.render_priority = material.render_priority
	materials = [material, material2]
	material.next_pass = material2
	material2.next_pass = null
	sprite.material_override = material
	originally_flipped = sprite.flip_h
	
	animator = find_animator(scene)
	if animator and not animator.has_method("x_play"):
		animator.set_script(ExtendedAnimationPlayerFallback)
	
	tween = Tween.new()
	add_child(tween)

func _ready():
	if animator:
		animator.set_idle(idle)
		animator.set_alt_idle(alt_idle)
	play_animation(idle)

func find_animator(scene:Node)->AnimationPlayer:
	if not scene.has_node(NodePath("AnimationPlayer")):
		return null
	return scene.get_node(NodePath("AnimationPlayer")) as AnimationPlayer

func _select_shader()->Shader:
	if albedo.a < 1.0 or not scissor_enabled:
		return SpriteShaderUnshaded if unshaded else SpriteShader
	return ScissorShaderUnshaded if unshaded else ScissorShader

func _select_first_pass_shader()->Shader:
	if render_through:
		return RenderThroughShaderUnshaded if unshaded else RenderThroughShader
	return _select_shader()

func fix_material(material:Material)->ShaderMaterial:
	if material is ShaderMaterial:
		var new_material = material.duplicate() as ShaderMaterial
		new_material.set_shader_param("texture_albedo", sprite.texture)
		return new_material
		
	elif material is SpatialMaterial:
		var new_material = ShaderMaterial.new()
		unshaded = material.flags_unshaded
		new_material.shader = _select_shader()
		new_material.set_shader_param("albedo", material.albedo_color)
		new_material.set_shader_param("texture_albedo", sprite.texture)
		new_material.set_shader_param("flags_albedo_tex_force_srgb", material.flags_albedo_tex_force_srgb)
		new_material.set_shader_param("specular", material.metallic_specular)
		new_material.set_shader_param("roughness", material.roughness)
		new_material.set_shader_param("point_size", material.params_point_size)
		new_material.set_shader_param("emission", material.emission)
		new_material.set_shader_param("emission_energy", material.emission_energy)
		new_material.set_shader_param("uv1_scale", material.uv1_scale)
		new_material.set_shader_param("uv1_offset", material.uv1_offset)
		new_material.set_shader_param("uv2_scale", material.uv2_scale)
		new_material.set_shader_param("uv2_offset", material.uv2_offset)
		new_material.set_shader_param("billboard_mode", material.params_billboard_mode)
		return new_material
		
	else :
		var new_material = ShaderMaterial.new()
		new_material.shader = _select_shader()
		new_material.set_shader_param("texture_albedo", sprite.texture)
		return new_material

func set_idle(value:String):
	idle = value
	if animator:
		animator.set_idle(value)

func set_alt_idle(value:String):
	alt_idle = value
	if animator:
		animator.set_alt_idle(value)

func set_animation_prefix(value:String):
	animation_prefix = value
	if animator:
		animator.set_prefix(animation_prefix)
		if not animator.is_playing():
			animator.x_play(idle)

func set_param(name:String, value):
	if name == "render_through":
		render_through = value
		if not custom_shader:
			material.shader = _select_first_pass_shader()
			material2.shader = _select_shader()
		return 
	elif name == "billboard_depth_hack":
		
		material.set_shader_param(name, value)
		return 

	if name == "albedo":
		var was_transparent = albedo.a < 1.0
		albedo = value
		
		if albedo.a < 1.0 and not was_transparent:
			
			material.render_priority = int(max(TRANSPARENT_RENDER_PRIORITY, render_priority))
		elif albedo.a >= 1.0 and was_transparent:
			material.render_priority = render_priority
		
		if not custom_shader:
			material.shader = _select_first_pass_shader()
			material2.shader = _select_shader()
	
	for m in materials:
		m.set_shader_param(name, value)
	
	if name == "wave_amplitude":
		set_process(value != 0.0)
		if value != 0.0:
			_process_material()

func get_param(name:String):
	if name == "render_through":
		return material.shader == RenderThroughShader or material.shader == RenderThroughShaderUnshaded
	var value = material.get_shader_param(name)
	if value == null:
		if material.property_can_revert(name):
			value = material.property_get_revert(name)
	return value

func set_swap_colors(value:Array):
	swap_colors = value
	for i in range(NumSwapColors):
		for m in materials:
			m.set_shader_param("swap_from_" + str(i), swap_colors[i] if i < swap_colors.size() else Color(0))

func set_default_palette(value:Array):
	default_palette = value
	for i in range(NumSwapColors):
		for m in materials:
			m.set_shader_param("swap_default_" + str(i), value[i] if i < value.size() and i < swap_colors.size() else Color(0))

func _set_palette(value:Array):
	palette = value
	for i in range(NumSwapColors):
		for m in materials:
			m.set_shader_param("swap_to_" + str(i), value[i] if i < value.size() and i < swap_colors.size() else Color(0))

func set_palette(value:Array):
	_set_palette(value)
	set_swap_blend(0.0 if value.size() == 0 else 1.0)

func set_emission_palette(value:Array):
	emission_palette = value
	for i in range(NumEmissionColors):
		for m in materials:
			m.set_shader_param("emission_color_" + str(i), value[i] if i < value.size() else Color(0))

func set_swap_blend(value:float):
	for m in materials:
		m.set_shader_param("swap_blend", value)

func tween_palette(end_palette:Array, duration:float):
	if palette == end_palette:
		return Co.pass()
	if palette.size() > 0 and end_palette.size() > 0:
		tween.stop_all()
		tween.remove_all()
		tween.interpolate_method(self, "set_swap_blend", material.get_shader_param("swap_blend"), 0.0, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
		yield (Co.wait_for_tween(tween), "completed")
		_set_palette(end_palette)
		tween.remove_all()
		tween.interpolate_method(self, "set_swap_blend", 0.0, 1.0, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
		yield (Co.wait_for_tween(tween), "completed")
	elif palette.size() > 0:
		assert (end_palette.size() == 0)
		tween.stop_all()
		tween.remove_all()
		tween.interpolate_method(self, "set_swap_blend", material.get_shader_param("swap_blend"), 0.0, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
		yield (Co.wait_for_tween(tween), "completed")
		_set_palette(end_palette)
	elif palette.size() == 0 and end_palette.size() > 0:
		_set_palette(end_palette)
		tween.stop_all()
		tween.remove_all()
		tween.interpolate_method(self, "set_swap_blend", material.get_shader_param("swap_blend"), 1.0, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
		yield (Co.wait_for_tween(tween), "completed")
	else :
		return Co.pass()

func set_flip_h(value:bool):
	sprite.flip_h = value != originally_flipped
	if value:
		sprite.offset = Vector2( - _get_texture_size().x - sprite_offset.x, sprite_offset.y)
	else :
		sprite.offset = sprite_offset

func set_render_priority(value:int):
	render_priority = value
	material.render_priority = render_priority

func set_scissor_enabled(value:bool):
	scissor_enabled = value
	if not custom_shader:
		if material:
			material.shader = _select_first_pass_shader()
		if material2:
			material2.shader = _select_shader()

func play_animation(name:String, random_position:bool = false, backwards:bool = false):
	if animator:
		if animator.x_play(name, backwards):
			if random_position:
				animator.seek(randf() * animator.current_animation_length)
			if not Engine.editor_hint:
				yield (animator, "animation_finished")
				return 
	if not Engine.editor_hint:
		return Co.pass()

func is_idle()->bool:
	if not animator:
		return true
	return animator.is_idle()

func wait_for_idle_sync():
	if not animator or not animator.is_playing():
		return Co.pass()
	yield (animator, "animation_finished")

func _get_texture_size()->Vector2:
	if sprite.region_enabled:
		return sprite.region_rect.size
	if sprite.texture != null:
		return Vector2(sprite.texture.get_width(), sprite.texture.get_height())
	return Vector2()

func _get_size()->Vector3:
	var size = _get_texture_size()
	return Vector3(size.x * sprite.pixel_size, size.y * sprite.pixel_size, 0.0)

func get_aabb():
	var result = AABB()
	result = result.expand(get_position(Vector2(0, 0)))
	result = result.expand(get_position(_get_texture_size()))
	return result

func _process(_delta):
	_process_material()

func _process_material():
	if material.get_shader_param("wave_amplitude") != 0.0:
		for m in materials:
			if sprite.region_enabled:
				m.set_shader_param("wave_min_u", float(sprite.region_rect.position.x) / float(sprite.texture.get_width()))
				m.set_shader_param("wave_max_u", float(sprite.region_rect.end.x) / float(sprite.texture.get_width()))
				m.set_shader_param("wave_min_v", float(sprite.region_rect.position.y) / float(sprite.texture.get_height()))
				m.set_shader_param("wave_max_v", float(sprite.region_rect.end.y) / float(sprite.texture.get_height()))
			else :
				m.set_shader_param("wave_min_u", 0.0)
				m.set_shader_param("wave_max_u", 1.0)
				m.set_shader_param("wave_min_v", 0.0)
				m.set_shader_param("wave_max_v", 1.0)
	else :
		set_process(false)

func _get_billboard_mode()->int:
	var result = material.get_shader_param("billboard_mode")
	if result == null:
		return 0
	return result

func get_sprite_size()->Vector2:
	var w = sprite.region_rect.size.x if sprite.region_enabled else float(sprite.texture.get_width())
	var h = sprite.region_rect.size.y if sprite.region_enabled else float(sprite.texture.get_height())
	return Vector2(w, h)

func get_position(pos)->Vector3:
	if not (pos is Vector2):
		return Vector3()
	if get_viewport() == null:
		return Vector3()
	var camera = get_viewport().get_camera()
	if camera == null:
		return Vector3()
	
	var global_basis = get_parent().global_transform.basis
	var basis = Basis.IDENTITY.rotated(Vector3(0, 1, 0), global_basis.get_euler().y)
	
	var camera_basis = camera.global_transform.basis
	var up = basis.xform_inv(camera_basis.xform(Vector3(0, - 1, 0)))
	var right = basis.xform_inv(camera_basis.xform(Vector3(1, 0, 0)))
	
	var size = get_sprite_size()
	
	if originally_flipped:
		pos.x = size.x - pos.x
	if sprite.flip_v:
		pos.y = size.y - pos.y
	
	var point = Vector2(pos.x + sprite_offset.x, size.y - pos.y + sprite_offset.y) * sprite.pixel_size
	
	var billboard = _get_billboard_mode()
	if billboard == 2:
		return point.x * right + Vector3(0, point.y, 0)
	elif billboard >= 1:
		return point.x * right - point.y * up
	else :
		return Vector3(point.x, point.y, 0)

func set_flag(_flag:String, _value:bool):
	pass

func set_direction(value:String):
	direction = value
	if animator:
		animator.set_suffix("_" + value)
		if not animator.is_playing():
			animator.x_play(idle)

func set_animation_speed(value:float):
	animation_speed = value
	if animator:
		animator.playback_speed = animation_speed
