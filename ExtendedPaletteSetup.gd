extends Control

const Backgrounds = preload("res://battle/backgrounds/battle_backgrounds.tres").resources
var ElementalTypes = Datatables.load("res://data/elemental_types")
const extended_form = "MonsterForm_Ext.gd"
onready var background = $ViewportContainer / Viewport / Background
onready var monster_button = $VBoxContainer / Buttons / MonsterButton
onready var fusion_button = $VBoxContainer / Buttons / FusionButton
onready var coating_button = $VBoxContainer / Buttons / CoatingButton
onready var animation_button = $VBoxContainer / Buttons / AnimationButton
onready var background_button = $VBoxContainer / Buttons / BackgroundButton
onready var fusion_name_label = $VBoxContainer / FusionName
onready var generate_button = $VBoxContainer/GeneratePalette
onready var save_button = $VBoxContainer/SaveButton
onready var linkevo_button = $VBoxContainer/LinkEvo
onready var reset_button = $VBoxContainer/ResetPalette
onready var palette_container = $VBoxContainer2
onready var glitter_label = $VBoxContainer/Buttons/GlitterRegionLabel
onready var glitter_region_options = $VBoxContainer/Buttons/GlitterRegionOption
onready var astral_label = $VBoxContainer/Buttons/AstralRegionLabel
onready var astral_region_options = $VBoxContainer/Buttons/AstralRegionOption
onready var color1 = $VBoxContainer2/GridContainer/VBoxContainer2/Color1
onready var color2 = $VBoxContainer2/GridContainer/VBoxContainer2/Color2
onready var color3 = $VBoxContainer2/GridContainer/VBoxContainer2/Color3
onready var color4 = $VBoxContainer2/GridContainer/VBoxContainer2/Color4
onready var color5 = $VBoxContainer2/GridContainer/VBoxContainer2/Color5
onready var color6 = $VBoxContainer2/GridContainer/VBoxContainer2/Color6
onready var color7 = $VBoxContainer2/GridContainer/VBoxContainer2/Color7
onready var color8 = $VBoxContainer2/GridContainer/VBoxContainer2/Color8
onready var color9 = $VBoxContainer2/GridContainer/VBoxContainer2/Color9
onready var color10 = $VBoxContainer2/GridContainer/VBoxContainer2/Color10
onready var color11 = $VBoxContainer2/GridContainer/VBoxContainer2/Color11
onready var color12 = $VBoxContainer2/GridContainer/VBoxContainer2/Color12
onready var color13 = $VBoxContainer2/GridContainer/VBoxContainer2/Color13
onready var color14 = $VBoxContainer2/GridContainer/VBoxContainer2/Color14
onready var color15 = $VBoxContainer2/GridContainer/VBoxContainer2/Color15
onready var color16 = $VBoxContainer2/GridContainer/VBoxContainer4/Color16
onready var color17 = $VBoxContainer2/GridContainer/VBoxContainer4/Color17
onready var color18 = $VBoxContainer2/GridContainer/VBoxContainer4/Color18
onready var color19 = $VBoxContainer2/GridContainer/VBoxContainer4/Color19
onready var color20 = $VBoxContainer2/GridContainer/VBoxContainer4/Color20
onready var color21 = $VBoxContainer2/GridContainer/VBoxContainer4/Color21
onready var color22 = $VBoxContainer2/GridContainer/VBoxContainer4/Color22
onready var color23 = $VBoxContainer2/GridContainer/VBoxContainer4/Color23
onready var color24 = $VBoxContainer2/GridContainer/VBoxContainer4/Color24
onready var color25 = $VBoxContainer2/GridContainer/VBoxContainer4/Color25
onready var color26 = $VBoxContainer2/GridContainer/VBoxContainer4/Color26
onready var color27 = $VBoxContainer2/GridContainer/VBoxContainer4/Color27
onready var color28 = $VBoxContainer2/GridContainer/VBoxContainer4/Color28
onready var color29 = $VBoxContainer2/GridContainer/VBoxContainer4/Color29
onready var color30 = $VBoxContainer2/GridContainer/VBoxContainer4/Color30
onready var color_ref_sheet = $ColorRefSheet
onready var colorref1 = $ColorRefSheet/RefColor1
onready var colorref2 = $ColorRefSheet/RefColor2
onready var colorref3 = $ColorRefSheet/RefColor3
onready var colorref4 = $ColorRefSheet/RefColor4
onready var colorref5 = $ColorRefSheet/RefColor5
onready var colorpicker_pos = $ColorPickerPos
onready var colorpicker_pos2 = $ColorPickerPos2
var mod_name = "bootleg_mod"
var tool_info = preload("palette_info.tres")
var monster_forms:Array = []
var slot
var glitter_region_memory = {}
var astral_region_memory = {}

func _ready():
	GlobalUI.manage_visibility($VBoxContainer)
	monster_forms = Datatables.load("res://data/monster_forms/").table.values() + Datatables.load("res://data/monster_forms_secret/").table.values()	

	# Sort forms by bestiary_index (ascending)
	monster_forms.sort_custom(self, "_sort_by_bestiary_index")
	
	var popup = monster_button.get_popup()
	popup.connect("about_to_show", self, "_on_popup_about_to_show")
	
	var i = 0
	for form in monster_forms:		
		monster_button.add_item(form.name, i)
		fusion_button.add_item("x " + tr(form.name), i + 1)
		i += 1
	i = 0
	for type in ElementalTypes.table.values():
		coating_button.add_item(type.name, i)
		i += 1
	coating_button.add_item("Default", i)
	for bg in Backgrounds:
		background_button.add_item(Datatables.get_db_key(bg))
	
	glitter_region_options.add_item("First Region")
	glitter_region_options.add_item("Second Region")
	glitter_region_options.add_item("Third Region")
	glitter_region_options.add_item("Fourth Region")
#	glitter_region_options.add_item("Fifth Region", 4)
#	glitter_region_options.add_item("First+Second Region", 4)
#	glitter_region_options.add_item("First+Third Region", 5)
#	glitter_region_options.add_item("Second+Third Region", 6)
	
	astral_region_options.add_item("First Region")
	astral_region_options.add_item("Second Region")
	astral_region_options.add_item("Third Region")
	astral_region_options.add_item("Fourth Region")
#	astral_region_options.add_item("Fifth Region", 4)
#	astral_region_options.add_item("First+Second Region", 4)
#	astral_region_options.add_item("First+Third Region", 5)
#	astral_region_options.add_item("Second+Third Region", 6)

	mod_name = get_project_info(get_current_monster_name())
	update_slots()


func _on_popup_about_to_show():
	var popup = monster_button.get_popup()
	var max_height = 300

	if popup.rect_size.y > max_height:
		popup.rect_size.y = max_height




var start_index = 34

func _sort_by_bestiary_index(a, b):
#	return a.bestiary_index < b.bestiary_index
	var a_index = a.bestiary_index
	var b_index = b.bestiary_index

	var a_wrapped = (a_index - start_index + 10000) % 10000
	var b_wrapped = (b_index - start_index + 10000) % 10000

	return a_wrapped < b_wrapped


func update_slots():
	var slots = background.get_slots()
	slot = background.get_slots()[0]
	for j in range(1, slots.size()):
		slots[j].clear()
	
	slot.translation.x = 0.0

	update_selection()

func update_selection():
	var tape = MonsterTape.new()	
	var form = monster_forms[monster_button.get_selected_id()]
	mod_name = get_project_info(get_current_monster_name())
	if form.get("extended_type_palettes"):
		
		generate_button.visible = false
		save_button.visible = true
		linkevo_button.visible = true
		reset_button.visible = coating_button.get_selected_id() != 99 
		palette_container.visible = true	
		if coating_button.get_selected_id() == ElementalTypes.table.values().size():
			glitter_label.visible = false
			glitter_region_options.visible = false
			
			astral_label.visible = false
			astral_region_options.visible = false
			
		else:
			glitter_label.visible = coating_button.get_selected_id() != 99 and ElementalTypes.table.values()[coating_button.get_selected_id()].id == "glitter"
			glitter_region_options.visible = coating_button.get_selected_id() != 99 and ElementalTypes.table.values()[coating_button.get_selected_id()].id == "glitter"
			
			astral_label.visible = coating_button.get_selected_id() != 99 and ElementalTypes.table.values()[coating_button.get_selected_id()].id == "astral"
			astral_region_options.visible = coating_button.get_selected_id() != 99 and ElementalTypes.table.values()[coating_button.get_selected_id()].id == "astral"
			
		color_ref_sheet.visible = coating_button.get_selected_id() != 99 and not (coating_button.get_selected_id() == ElementalTypes.table.values().size())	
	else:
		generate_button.visible = true
		save_button.visible = false
		linkevo_button.visible = false
		reset_button.visible = false		
		palette_container.visible = false
		color_ref_sheet.visible = false
		glitter_label.visible = false
		glitter_region_options.visible = false
		
		astral_label.visible = false
		astral_region_options.visible = false
		
	tape.set_form(form)
	form = tape.create_form()	
	slot.set_form(form)
	if coating_button.get_selected_id() == ElementalTypes.table.values().size():
		if form.default_palette.size() == 0:
			form.default_palette = form.swap_colors.duplicate()
		set_ui_palette(form.default_palette)
	else:
		set_ui_palette(form.swap_colors)
	if coating_button.get_selected_id() != 99 and not coating_button.get_selected_id() == ElementalTypes.table.values().size():
		var type = ElementalTypes.table.values()[coating_button.get_selected_id()]
		tape.type_override = []
		tape.type_override.push_back(type)
		form = tape.create_form()
		if form.get("extended_type_palettes"):
			
			if form.glitter_region.size() > 0 and form.glitter_region[0] == 0:
				glitter_region_options.select(0)
			if form.glitter_region.size() > 0 and form.glitter_region[0] == 5:
				glitter_region_options.select(1)
			if form.glitter_region.size() > 0 and form.glitter_region[0] == 10:
				glitter_region_options.select(2)
			if form.glitter_region.size() > 0 and form.glitter_region[0] == 15:
				glitter_region_options.select(3)
#			if form.glitter_region.size() > 0 and form.glitter_region[0] == 20:
#				glitter_region_options.select(4)
#			if form.glitter_region.size() > 0 and form.glitter_region[0] == 1:
#				glitter_region_options.select(4)
#			if form.glitter_region.size() > 0 and form.glitter_region[0] == 2:
#				glitter_region_options.select(5)
#			if form.glitter_region.size() > 0 and form.glitter_region[0] == 6:
#				glitter_region_options.select(6)
#
			if form.astral_region.size() > 0 and form.astral_region[0] == 0:
				astral_region_options.select(0)
			if form.astral_region.size() > 0 and form.astral_region[0] == 5:
				astral_region_options.select(1)
			if form.astral_region.size() > 0 and form.astral_region[0] == 10:
				astral_region_options.select(2)
			if form.astral_region.size() > 0 and form.astral_region[0] == 15:
				astral_region_options.select(3)
#			if form.astral_region.size() > 0 and form.astral_region[0] == 20:
#				astral_region_options.select(4)
#			if form.astral_region.size() > 0 and form.astral_region[0] == 20:
#				astral_region_options.select(4)
#			if form.astral_region.size() > 0 and form.astral_region[0] == 25:
#				astral_region_options.select(5)
#			if form.astral_region.size() > 0 and form.astral_region[0] == 30:
#				astral_region_options.select(6)

			set_ui_palette(form.extended_type_palettes[type.id])
			set_type_refsheet(type)
		slot.set_form(form)

	if fusion_button.get_selected_id() > 0:
		var fuse_with = monster_forms[fusion_button.get_selected_id() - 1]
		var fusion = Fusions.fuse_forms([form, fuse_with], 0)
		slot.set_form(fusion)
		fusion_name_label.text = fusion.name
	else :
		slot.set_form(form)
		fusion_name_label.text = ""	
		
	slot.sprite_container.idle = animation_button.text
	if animation_button.text != "idle":
		slot.sprite_container.alt_idle = animation_button.text
	else :
		slot.sprite_container.alt_idle = ""

func set_type_refsheet(type):
	colorref1.color = type.palette[0]
	colorref2.color = type.palette[1]
	colorref3.color = type.palette[2]
	colorref4.color = type.palette[3]
	colorref5.color = type.palette[4]


func set_ui_palette(colors):
	var color_nodes = [
		color1, color2, color3, color4, color5, color6, color7, color8, color9, color10,
		color11, color12, color13, color14, color15, color16, color17, color18, color19, color20,
		color21, color22, color23, color24, color25, color26, color27, color28, color29, color30,
	]
	
#	for i in range(min(colors.size(), color_nodes.size())):
#		color_nodes[i].color = colors[i]

	# Pad colors array to 30 if needed
	if colors.size() < 30:
		pad_swap_colors_to_30(colors)

	for i in range(min(colors.size(), color_nodes.size())):
		var target_color = colors[i]
		if target_color == null:
			target_color = Color.black

		if color_nodes[i] != null:
			color_nodes[i].color = target_color

	
func _on_item_selected(_id):
	update_selection()

func _on_SpinBox_value_changed(_value):
	update_selection()

func _on_BackgroundButton_item_selected(id):
	var bg_parent = background.get_parent()
	bg_parent.remove_child(background)
	background.queue_free()
	background = Backgrounds[id].instance()
	bg_parent.add_child(background)
	update_slots()
	
func duplicate_monster_data(form, original_data):	
	form.name = original_data.name
	form.swap_colors = original_data.swap_colors.duplicate()

#	for color in original_data.emission_palette:
#		form.swap_colors.append(color)

	form.default_palette = original_data.swap_colors.duplicate()
	form.emission_palette = original_data.emission_palette.duplicate()
	pad_swap_colors_to_30(form.swap_colors)

	for i in range(min(original_data.emission_palette.size(), 15)):
		form.swap_colors[15 + i] = original_data.emission_palette[i]
		form.default_palette[15 + i] = original_data.emission_palette[i]

	form.battle_cry = original_data.battle_cry
	form.defeat_cry = original_data.defeat_cry
	form.named_positions = original_data.named_positions
	form.elemental_types = original_data.elemental_types
	form.tape_sticker_texture = original_data.tape_sticker_texture
	form.exp_yield = original_data.exp_yield
	form.require_dlc = original_data.require_dlc
	form.battle_sprite_path = original_data.battle_sprite_path
	form.ui_sprite_path = original_data.ui_sprite_path
	form.pronouns = original_data.pronouns
	form.description = original_data.description
	form.max_hp = original_data.max_hp
	form.melee_attack = original_data.melee_attack
	form.melee_defense = original_data.melee_defense
	form.ranged_attack = original_data.ranged_attack
	form.ranged_defense = original_data.ranged_defense
	form.speed = original_data.speed
	form.evasion = original_data.evasion
	form.max_ap = original_data.max_ap
	form.move_slots = original_data.move_slots
	form.evolutions = original_data.evolutions.duplicate()
	form.evolution_specialization_question = original_data.evolution_specialization_question
	form.capture_rate = original_data.capture_rate
	form.exp_gradient = original_data.exp_gradient
	form.exp_base_level = original_data.exp_base_level
	form.move_tags = original_data.move_tags.duplicate()
	form.initial_moves = original_data.initial_moves.duplicate()
	form.tape_upgrades = original_data.tape_upgrades.duplicate()
	form.unlock_ability = original_data.unlock_ability
	form.fusion_name_prefix = original_data.fusion_name_prefix
	form.fusion_name_suffix = original_data.fusion_name_suffix
	form.fusion_generator_path = original_data.fusion_generator_path
	form.bestiary_index = original_data.bestiary_index
	form.bestiary_category = original_data.bestiary_category
	form.bestiary_bios = original_data.bestiary_bios.duplicate()
	form.bestiary_data_requirement = original_data.bestiary_data_requirement
	form.bestiary_data_requirement_flag = original_data.bestiary_data_requirement_flag
	form.loot_table = original_data.loot_table




func pad_swap_colors_to_30(colors: Array) -> void:
	while colors.size() < 30:
		colors.append(Color.black)
		
		
		
func generate_extended_form()->String:
	var form = monster_forms[monster_button.get_selected_id()]
	var original_path:String = form.resource_path
	var base_name:String = original_path.get_basename()
	var monster_name = base_name.get_slice("/",4)	
	var form_ext ="MonsterForm_Ext.gd"
	var mod_path = "res://mods/"+mod_name
	var extended_monster_file = mod_path+"/"+monster_name+"_ext.tres"	 
	var dir = Directory.new()

	if not dir.dir_exists(mod_path):
		create_directory(dir, mod_path)

	if dir.open(mod_path) == OK:			
		var new_form = MonsterForm.new()
		new_form.set_script(load(mod_path+"/"+form_ext))
		var original_data = load(original_path)
		duplicate_monster_data(new_form, original_data)
		var ElementalTypes = Datatables.load("res://data/elemental_types").table.values()

		for type in ElementalTypes:
			new_form.extended_type_palettes[type.id] = new_form.swap_colors.duplicate()	
		new_form.glitter_region = [0,1,2,3,4]	
		new_form.astral_region = [0,1,2,3,4]
		var err = ResourceSaver.save(extended_monster_file, new_form)

		if err == OK:
			new_form.take_over_path(original_path)
			replace_default_form(new_form)
			return "Generated " + extended_monster_file +" ."

	return "Failed to Generate modded monster resource file."

func generate_metadata_file(modload_script, folder)->String:
	var metadata_path = folder + "/metadata.tres"
	var dir = Directory.new()

	if dir.file_exists(metadata_path):
		return "metadata.tres already exists, no further action required."

	var metadata = ContentInfo.new()
	metadata.set_script(modload_script)
	var err = ResourceSaver.save(folder+"/metadata.tres", metadata)
	if err != OK:
		return "Failed to create metadata.tres file."
	return "Generated " + folder+"/metadata.tres ."

#func generate_metadata_file(modload_script, folder)->String:
#	var metadata_path = folder + "/metadata.tres"
#	var dir = Directory.new()
#
#	if dir.file_exists(metadata_path):
#		return "metadata.tres already exists, no further action required."
#
#	var metadata = ContentInfo.new()
#	metadata.set_script(modload_script)
#
#	# First save establishes the metadata resource.
#	var err = ResourceSaver.save(metadata_path, metadata)
#
#	if err != OK:
#		return "Failed to create metadata.tres file."
#
#	# Now modify the already-established resource.
#	var modified_files:Array = metadata.get("modified_files")
#
#	modified_files.append("res://mods/cat_qol/bootleg_noise.gd")
#	modified_files.append("res://mods/Tape Re-Release/EvolutionMenu.tscn")
#
#	metadata.set("modified_files", modified_files)
#
#	print("BEFORE SECOND SAVE: ", metadata.get("modified_files"))
#
#	err = ResourceSaver.save(metadata_path, metadata)
#
#	if err != OK:
#		return "Failed to update metadata.tres file."
#
#	return "Generated " + metadata_path + " ."


func generate_monster_form_file()->String:
	var form = monster_forms[monster_button.get_selected_id()]
	var original_path:String = form.resource_path
	var base_name:String = original_path.get_basename()
	var monster_name = base_name.get_slice("/",4)
	var mod_path = "res://mods/"+mod_name
	var file_name ="MonsterForm_Ext.gd"    
	var dir = Directory.new()
	if not dir.dir_exists(mod_path):
		create_directory(dir, mod_path)
	if dir.file_exists(mod_path+"/"+file_name):
		return "MonsterForm_Ext.gd already exists, no further action required."
	if dir.open(mod_path) == OK:		
		var source_code := """extends MonsterForm

export (Dictionary) var extended_type_palettes 
export (Array, int) var glitter_region
export (Array, int) var astral_region

func create_type_variant(types:Array)->Resource:
	if types.size() == 0:
		return self
	var result = duplicate()
	result._variant_of = _get_original()
	result.elemental_types = types
	var new_type = types[0].duplicate()
	if is_glitter_type(new_type):
		var form_palette:Array = result.swap_colors.duplicate()
		var index:int = 0
		for glitter_index in glitter_region:
			result.swap_colors[index] = form_palette[glitter_index]
			result.swap_colors[glitter_index] = form_palette[index]
			index += 1			
			
	if is_astral_type(new_type):
		var form_palette:Array = result.swap_colors.duplicate()
		var index:int = 0
		for astral_index in astral_region:
			result.swap_colors[index] = form_palette[astral_index]
			result.swap_colors[astral_index] = form_palette[index]
			index += 1			
			
	new_type.palette = extended_type_palettes[new_type.id]
	result.default_palette = new_type.generate_recolor_palette(result.default_palette, result.swap_colors)
	return result

func is_glitter_type(type)->bool:
	return type.id == "glitter"
	
func is_astral_type(type)->bool:
	return type.id == "astral"
	
		"""

		var new_script = GDScript.new()
		new_script.source_code = source_code
		new_script.resource_path = mod_path+"/"+file_name	
		var err = ResourceSaver.save(new_script.resource_path, new_script)
		if err != OK:
			return "Failed to generate MonsterForm_Ext.gd file. Error code: %s" % str(err)
		
		return "Generated " + new_script.resource_path +" ."
	return "Failed to open mod folder path: " + mod_path +"."

func generate_mod_load_script()->String:
	var form = monster_forms[monster_button.get_selected_id()]
	var original_path:String = form.resource_path
	var base_name:String = original_path.get_basename()
	var monster_name = base_name.get_slice("/",4)

	var mod_path = "res://mods/"+mod_name
	var file_name ="mod_load.gd"
	var extended_monster_file = mod_path+"/"+monster_name+"_ext.tres"

	var dir = Directory.new()

	if not dir.dir_exists(mod_path):
		create_directory(dir, mod_path)

	if dir.file_exists(mod_path+"/"+file_name):
		var filepath = mod_path+"/"+file_name
		var script:GDScript = load(filepath)
		var code_lines:Array = script.source_code.split("\n")
		var already_added = script.source_code.find(extended_monster_file) != -1
		var line_index = code_lines.find("func _apply_monster_patches() -> void:")
		var variable_string = monster_name+"_resource"
		var new_preload_code = """	patch_monster_palette(
		"%s",
		"%s")""" % [original_path, extended_monster_file]

		if already_added:
			return "Entry already exists in " + script.resource_path + " ."
	
		if line_index >= 0 and not already_added:
			var insert_index = code_lines.size()

			# Find the next top-level function after init_content().
			for i in range(line_index + 1, code_lines.size()):
				if code_lines[i].begins_with("func "):
					insert_index = i
					break

			code_lines.insert(insert_index, new_preload_code)
		script.source_code = ""
		for line in code_lines:
			script.source_code += line + "\n"	
		var err = ResourceSaver.save(script.resource_path, script)
		if err == OK:
			var message = generate_metadata_file(script, mod_path)
			return message + "\n" + "Regenerated " + script.resource_path +" ."
	if dir.open(mod_path) == OK:		
		var source_code := """extends ContentInfo
#Patch Function
var _patched_monsters = {}
func patch_monster_palette(target_path:String, donor_path:String) -> void:
	var target:Resource = load(target_path)
	var donor:Resource = load(donor_path)

	if target == null:
		print("Could not load target: ", target_path)
		return

	if donor == null:
		print("Could not load donor: ", donor_path)
		return

	# 1. SAVE THE CURRENT MONSTER'S DATA BEFORE CHANGING SCRIPT
	var saved_properties = {}

	for property in target.get_property_list():
		var property_name:String = property["name"]
		var usage:int = property["usage"]

		# Only preserve properties that are actually stored.
		# Do NOT preserve "script", otherwise we'd be back to the original MonsterForm script.
		if property_name != "script" and (usage & PROPERTY_USAGE_STORAGE) != 0:
			saved_properties[property_name] = target.get(property_name)

	# 2. CHANGE TO MODDED MONSTERFORM SCRIPT
	target.set_script(
		load("%s/MonsterForm_Ext.gd"))

	# 3. FIND WHICH PROPERTIES THE NEW SCRIPT SUPPORTS
	var new_properties = {}

	for property in target.get_property_list():
		new_properties[property["name"]] = true

	# 4. RESTORE THE MONSTER DATA
	for property_name in saved_properties:
		if new_properties.has(property_name):
			target.set(
				property_name,
				saved_properties[property_name])

	# 5. NOW APPLY MODDED PALETTE DATA
	target.set(
		"swap_colors",
		donor.get("swap_colors").duplicate(true))

	target.set(
		"default_palette",
		donor.get("default_palette").duplicate(true))

	target.set(
		"emission_palette",
		donor.get("emission_palette").duplicate(true))

	target.set(
		"extended_type_palettes",
		donor.get("extended_type_palettes").duplicate(true))

	target.set(
		"glitter_region",
		donor.get("glitter_region").duplicate(true))

	target.set(
		"astral_region",
		donor.get("astral_region").duplicate(true))

	_patched_monsters[target_path] = target

	print("Live palette patch applied to ",target_path)
	

var _patched_spawn_profiles = {}
var use_static = false
func patch_overworld(use_static:bool) -> void:
	var folder_path:String = "res://data/monster_spawn_profiles"
	var dir = Directory.new()
	var file = File.new()

	if dir.open(folder_path) != OK:
		print("Could not open spawn profile folder: ", folder_path)
		return

	dir.list_dir_begin(true, true)

	var file_name:String = dir.get_next()

	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			var profile_path:String = folder_path + "/" + file_name
			var profile:Resource = load(profile_path)

			if profile != null:
				var changed:bool = false
				var num_species:int = profile.get("num_species")

				for i in range(num_species):
					var property_name:String = "species_%%d/world_monster" %% i
					var world_scene = profile.get(property_name)

					if world_scene == null:
						continue

					var world_path:String = world_scene.resource_path

					if not world_path.begins_with("res://world/monsters/"):
						continue

					var monster_name:String = world_path.get_file().get_basename()

					var suffix:String = "_ext.tscn"

					if use_static:
						suffix = "_ext_Static.tscn"

					var replacement_path:String = "%s/shadersoverride/overworld/" + monster_name + suffix

					if not file.file_exists(replacement_path):
						continue

					var replacement:PackedScene = load(replacement_path)

					if replacement == null:
						continue

					profile.set(property_name, replacement)
					changed = true

				if changed:
					_patched_spawn_profiles[profile_path] = profile

		file_name = dir.get_next()

	dir.list_dir_end()


func _init():	
	var file := File.new()

# 30 colors enabler
	var battleslot:Resource = preload("%s/shadersoverride/BattleSlot_ext.tscn")
	var monsterspritecontainer:Resource = preload("%s/shadersoverride/MonsterSpriteContainer_ext.tscn")
	var evolutionmenu:Resource = preload("%s/shadersoverride/EvolutionMenu_ext.tscn")
	var itemdrop:Resource = preload("%s/shadersoverride/ItemDrop_ext.tscn")
	

	if file.file_exists("res://mods/zBattleCry_Tapes/shadersoverride/BattleSlot_ext.tscn"):
		var battleslotBC:Resource = preload("%s/shadersoverride/BattleSlot_Cry_ext.tscn")
		battleslotBC.take_over_path("res://nodes/battle_slot/BattleSlot.tscn")
		print("Battle Cry detected, applying BC override.")

	else:
		battleslot.take_over_path("res://nodes/battle_slot/BattleSlot.tscn")
		print("Battle Cry not found, skipping override.")
	

	if file.file_exists("res://mods/Tape Re-Release/evo.gd"):
		var evolutiontrr:Resource = preload("%s/shadersoverride/EvolutionMenu_TRR.tscn")
		evolutiontrr.take_over_path("res://mods/Tape Re-Release/EvolutionMenu.tscn")
		print("Tape Re-Release detected, applying override.")

	else:
		evolutionmenu.take_over_path("res://menus/evolution/EvolutionMenu.tscn")
		print("Tape Re-Release not found, skipping MonsterSpriteContainer override.")
	
	monsterspritecontainer.take_over_path("res://menus/party/MonsterSpriteContainer.tscn")
	itemdrop.take_over_path("res://world/core/ItemDrop.tscn")

	# Overworld
	if file.file_exists("res://mods/static_backups/MonsterPalette.gd"):
		use_static = true

func init_content():
	call_deferred("_apply_monster_patches")

func _apply_monster_patches() -> void:
	patch_overworld(use_static)
	patch_monster_palette(
		"%s",
		"%s")
		""" % [mod_path, mod_path, mod_path, mod_path, mod_path, mod_path, mod_path, mod_path, original_path, extended_monster_file]

		var new_script = GDScript.new()
		new_script.source_code = source_code
		new_script.resource_path = mod_path+"/"+file_name
		var err = ResourceSaver.save(new_script.resource_path, new_script)
		if err == OK:
			var message = generate_metadata_file(new_script, mod_path)
			return message + "\n" + "Generated " + new_script.resource_path +" ."
	return "Failed to open mod folder path: " + mod_path + " ."



func copy_retargeted_file(source_path:String, destination_path:String, mod_path:String) -> bool:
	var file = File.new()

	if not file.file_exists(source_path):
		print("Missing template file: ", source_path)
		return false

	if file.open(source_path, File.READ) != OK:
		print("Could not read template file: ", source_path)
		return false

	var text:String = file.get_as_text()
	file.close()

	# Retarget anything pointing back to Skele Bootlegs.
	text = text.replace(
		"res://mods/zSkele_Bootlegs", mod_path)

	if file.open(destination_path, File.WRITE) != OK:
		print("Could not write generated file: ", destination_path)
		return false

	file.store_string(text)
	file.close()

	return true

func copy_shader_folder(source_path:String, destination_path:String, mod_path:String) -> void:
	var dir = Directory.new()
	var file = File.new()

	if not dir.dir_exists(destination_path):
		dir.make_dir_recursive(destination_path)

	if dir.open(source_path) != OK:
		print("Could not open template folder: ", source_path)
		return

	dir.list_dir_begin(true, true)

	var file_name:String = dir.get_next()

	while file_name != "":
		var source_file:String = source_path + "/" + file_name
		var destination_file:String = destination_path + "/" + file_name

		if dir.current_is_dir():
			copy_shader_folder(source_file, destination_file, mod_path)

		else:
			# Don't overwrite anything already generated.
			if dir.file_exists(destination_file):
				file_name = dir.get_next()
				continue

			# For scenes, check whether they reference a generated _ext.tres.
			if file_name.ends_with(".tscn"):
				if file.open(source_file, File.READ) == OK:
					var text:String = file.get_as_text()
					file.close()

					var lines:Array = text.split("\n")
					var missing_form:bool = false

					for line in lines:
						var path_start:int = line.find("res://mods/zSkele_Bootlegs/")

						if path_start == -1:
							continue

						var path_end:int = line.find("\"", path_start)

						if path_end == -1:
							continue

						var referenced_path:String = line.substr(path_start, path_end - path_start)

						# Only care about MonsterForm donor files.
						if not referenced_path.ends_with("_ext.tres"):
							continue

						var ext_tres_path:String = referenced_path.replace("res://mods/zSkele_Bootlegs", mod_path)

						if not dir.file_exists(ext_tres_path):
							missing_form = true
							break

					if missing_form:
						file_name = dir.get_next()
						continue

			copy_retargeted_file(source_file, destination_file, mod_path)

		file_name = dir.get_next()

	dir.list_dir_end()

func generate_shader_override_files() -> String:
	var mod_path:String = "res://mods/" + mod_name

	var template_path:String = \
		"res://tools/palette_extender_30/shadersoverride"

	var shader_path:String = \
		mod_path + "/shadersoverride"

	copy_shader_folder(template_path, shader_path, mod_path)

	return "Shader override files generated."



func create_directory(dir:Directory, folder:String):
	var result = dir.make_dir(folder)
	if result != OK:
		push_error("Failed to create folder "+folder)
		return false	

func _on_GeneratePalette_pressed():	
	var messages:Array = []
	var monster_name = get_current_monster_name()
	validate_mod_folder()
	if not has_project_info(monster_name):	
		mod_name = yield(MenuHelper.show_text_input("Mod Name", monster_name+"_bootleg_mod", 200),"completed")
		if mod_name == null:
			return
		set_project_info(monster_name)
	messages.push_back(generate_monster_form_file())
	messages.push_back(generate_extended_form())
	messages.push_back(generate_shader_override_files()) 
	messages.push_back(generate_mod_load_script())
	messages.push_back(add_metadata_modified_files())
	update_selection()
	yield (GlobalMessageDialog.show_message("Generation results: " + "\n" + messages[0] + "\n" + messages[1] + "\n" + messages[2] ),"completed")

func add_metadata_modified_files() -> String:
	var metadata_path:String = "res://mods/" + mod_name + "/metadata.tres"
	var file = File.new()

	file.open(metadata_path, File.READ)
	var text:String = file.get_as_text()
	file.close()

	text = text.replace(
		"script = ExtResource( 1 )",
		"""script = ExtResource( 1 )
modified_files = [ "res://mods/cat_qol/bootleg_noise.gd", "res://mods/Tape Re-Release/EvolutionMenu.tscn" ]"""
	)

	file.open(metadata_path, File.WRITE)
	file.store_string(text)
	file.close()

	return "Wrote metadata modified_files."




func get_current_monster_name()->String:
	var form = monster_forms[monster_button.get_selected_id()]
	var original_path:String = form.resource_path
	var base_name:String = original_path.get_basename()
	var monster_name = base_name.get_slice("/",4)	
	return monster_name

func get_project_info(monster_name:String)->String:
	if has_project_info(monster_name):
		return tool_info.project_folders[monster_name]
	
	return monster_name+"_bootleg_mod"	

func set_project_info(monster_name:String):
	if not tool_info:
		return
	if not has_project_info(monster_name):
		tool_info.project_folders[monster_name] = mod_name
		var result = ResourceSaver.save(tool_info.resource_path, tool_info)
		if result == OK:
			print("saved metadata")

func has_project_info(monster_name:String)->bool:
	return tool_info.project_folders.has(monster_name)	

func replace_default_form(new_form):	
	monster_forms[monster_button.get_selected_id()] = new_form

#func _on_Color_changed(color, index):
#	var form = monster_forms[monster_button.get_selected_id()]
#	if coating_button.get_selected_id() != 99 and not coating_button.get_selected_id() == ElementalTypes.table.values().size():
#		var type = ElementalTypes.table.values()[coating_button.get_selected_id()]
#		form.extended_type_palettes[type.id][index] = color
#		update_selection()
#	elif coating_button.get_selected_id() == ElementalTypes.table.values().size():	
#		form.default_palette[index] = color
#		slot.set_form(null)
#		update_selection()
#
#	else:
#		form.swap_colors[index] = color
#		update_selection()



func _on_Color_changed(color, index):
	var form = monster_forms[monster_button.get_selected_id()]
	
	if coating_button.get_selected_id() != 99 and not coating_button.get_selected_id() == ElementalTypes.table.values().size():
		var type = ElementalTypes.table.values()[coating_button.get_selected_id()]
		form.extended_type_palettes[type.id][index] = color
		update_selection()
	
	elif coating_button.get_selected_id() == ElementalTypes.table.values().size():    
		# Handle default palette color (base form, not emission)
		form.default_palette[index] = color
		slot.set_form(null)
		update_selection()
	
	else:
		# If modifying swap colors, allow modification of emission palette (indices 16–30)
		if index >= 16 and index < 30:  # emission color range
			form.swap_colors[index] = color  # Update swap color for emissions
		else:
			form.swap_colors[index] = color  # Regular palette swap
		update_selection()




func validate_mod_folder():
	var dir = Directory.new()
	if not dir.dir_exists("res://mods"):
		create_directory(dir, "res://mods")	

func _on_SaveButton_pressed():
	var form = monster_forms[monster_button.get_selected_id()]	
	if yield(MenuHelper.confirm("Are you sure you want to save changes to "+ Loc.tr(form.name)+"'s palettes?"),"completed"):
		var monster_name = get_current_monster_name()
		if not has_project_info(monster_name):
			yield(GlobalMessageDialog.show_message("Your existing bootleg mod does not have a project entry. Please input the name(case sensitive) of this mod's folder."),"completed")
			mod_name = yield(MenuHelper.show_text_input("Existing Mod Name", mod_name),"completed")
			set_project_info(monster_name)
		var mod_path = "res://mods/"+mod_name
		var extended_monster_file = mod_path+"/"+monster_name+"_ext.tres"

		var result = ResourceSaver.save(extended_monster_file, form)
		if result == OK:
			yield (GlobalMessageDialog.show_message("Saved all color palettes for " + Loc.tr(form.name)+"."),"completed")	
		else:
			yield (GlobalMessageDialog.show_message("Error saving " + extended_monster_file),"completed")	
			
func _on_Color_pressed(index):
	if index == 1:
		color1.get_popup().set_global_position(colorpicker_pos2.rect_position)
		color1.get_picker().presets_visible = false
	if index == 2:
		color2.get_popup().set_global_position(colorpicker_pos2.rect_position)
		color2.get_picker().presets_visible = false	
	if index == 3:
		color3.get_popup().set_global_position(colorpicker_pos2.rect_position)		
		color3.get_picker().presets_visible = false
	if index == 4:
		color4.get_popup().set_global_position(colorpicker_pos2.rect_position)
		color4.get_picker().presets_visible = false
	if index == 5:
		color5.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color5.get_picker().presets_visible = false
	if index == 6:
		color6.get_popup().set_global_position(colorpicker_pos2.rect_position)		
		color6.get_picker().presets_visible = false
	if index == 7:
		color7.get_popup().set_global_position(colorpicker_pos2.rect_position)
		color7.get_picker().presets_visible = false
	if index == 8:
		color8.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color8.get_picker().presets_visible = false
	if index == 9:
		color9.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color9.get_picker().presets_visible = false
	if index == 10:
		color10.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color10.get_picker().presets_visible = false
	if index == 11:
		color11.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color11.get_picker().presets_visible = false
	if index == 12:
		color12.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color12.get_picker().presets_visible = false	
	if index == 13:
		color13.get_popup().set_global_position(colorpicker_pos2.rect_position)		
		color13.get_picker().presets_visible = false
	if index == 14:
		color14.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color14.get_picker().presets_visible = false
	if index == 15:
		color15.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color15.get_picker().presets_visible = false
	if index == 16:
		color16.get_popup().set_global_position(colorpicker_pos2.rect_position)
		color16.get_picker().presets_visible = false
	if index == 17:
		color17.get_popup().set_global_position(colorpicker_pos2.rect_position)
		color17.get_picker().presets_visible = false	
	if index == 18:
		color18.get_popup().set_global_position(colorpicker_pos2.rect_position)		
		color18.get_picker().presets_visible = false
	if index == 19:
		color19.get_popup().set_global_position(colorpicker_pos2.rect_position)
		color19.get_picker().presets_visible = false
	if index == 20:
		color20.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color20.get_picker().presets_visible = false
	if index == 21:
		color21.get_popup().set_global_position(colorpicker_pos2.rect_position)		
		color21.get_picker().presets_visible = false
	if index == 22:
		color22.get_popup().set_global_position(colorpicker_pos2.rect_position)
		color22.get_picker().presets_visible = false
	if index == 23:
		color23.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color23.get_picker().presets_visible = false
	if index == 24:
		color24.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color24.get_picker().presets_visible = false
	if index == 25:
		color25.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color25.get_picker().presets_visible = false
	if index == 26:
		color26.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color26.get_picker().presets_visible = false
	if index == 27:
		color27.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color27.get_picker().presets_visible = false	
	if index == 28:
		color28.get_popup().set_global_position(colorpicker_pos2.rect_position)		
		color28.get_picker().presets_visible = false
	if index == 29:
		color29.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color29.get_picker().presets_visible = false
	if index == 30:
		color30.get_popup().set_global_position(colorpicker_pos2.rect_position)	
		color30.get_picker().presets_visible = false
																						
func _on_RefColor_pressed(index):
	if index == 1:
		colorref1.get_popup().set_global_position(colorpicker_pos.rect_position)
		colorref1.get_picker().presets_visible = false
	if index == 2:
		colorref2.get_popup().set_global_position(colorpicker_pos.rect_position)
		colorref2.get_picker().presets_visible = false
	if index == 3:
		colorref3.get_popup().set_global_position(colorpicker_pos.rect_position)
		colorref3.get_picker().presets_visible = false
	if index == 4:
		colorref4.get_popup().set_global_position(colorpicker_pos.rect_position)
		colorref4.get_picker().presets_visible = false
	if index == 5:
		colorref5.get_popup().set_global_position(colorpicker_pos.rect_position)
		colorref5.get_picker().presets_visible = false


func _on_GlitterRegionOption_item_selected(index):
	var form = monster_forms[monster_button.get_selected_id()]
	if form.get("glitter_region"):
		if not glitter_region_memory.has(form) and form.glitter_region.size() > 0:
			if form.glitter_region[0] == 0:
				glitter_region_memory[form] = 0
			if form.glitter_region[0] == 5:
				glitter_region_memory[form] = 1
			if form.glitter_region[0] == 10:
				glitter_region_memory[form] = 2
			if form.glitter_region[0] == 15:
				glitter_region_memory[form] = 3
#			if form.glitter_region[0] == 20:
#				glitter_region_memory[form] = 4
#			if form.glitter_region[0] == 1:
#				glitter_region_memory[form] = 4
#			if form.glitter_region[0] == 2:
#				glitter_region_memory[form] = 5
#			if form.glitter_region[0] == 6:
#				glitter_region_memory[form] = 6						
		if glitter_region_memory.has(form):
			swap_glitter_palette(glitter_region_memory[form])
		swap_glitter_palette(index)	
		glitter_region_memory[form] = index			
	update_selection()

func _on_AstralRegionOption_item_selected(index):
	var form = monster_forms[monster_button.get_selected_id()]
	if form.get("astral_region"):
		if not astral_region_memory.has(form) and form.astral_region.size() > 0:
			if form.astral_region[0] == 0:
				astral_region_memory[form] = 0
			if form.astral_region[0] == 5:
				astral_region_memory[form] = 1
			if form.astral_region[0] == 10:
				astral_region_memory[form] = 2
			if form.astral_region[0] == 15:
				astral_region_memory[form] = 3
#			if form.astral_region[0] == 20:
#				astral_region_memory[form] = 4
#			if form.astral_region[0] == 20:
#				astral_region_memory[form] = 4
#			if form.astral_region[0] == 25:
#				astral_region_memory[form] = 5
#			if form.astral_region[0] == 30:
#				astral_region_memory[form] = 6						
		if astral_region_memory.has(form):
			swap_astral_palette(astral_region_memory[form])
		swap_astral_palette(index)	
		astral_region_memory[form] = index			
	update_selection()


func swap_glitter_palette(swap_region):
	var form = monster_forms[monster_button.get_selected_id()]
	var type = ElementalTypes.table.values()[coating_button.get_selected_id()]	
	var type_palette = form.extended_type_palettes[type.id].duplicate()
	var index:int = 0
	if swap_region == 0:
		form.glitter_region = [0,1,2,3,4]
	if swap_region == 1:
		form.glitter_region = [5,6,7,8,9]
	if swap_region == 2:
		form.glitter_region = [10,11,12,13,14]
	if swap_region == 3:
		form.glitter_region = [15,16,17,18,19]
#		form.glitter_region = [15,16,17,18,19,20,21,22,23,24,25,26,27,28,29]
#	if swap_region == 4:
#		form.glitter_region = [20,21,22,23,24,5,6,7,8,9]
#	if swap_region == 4:
#		form.glitter_region = [1, 0, 2, 3, 4]
#		form.glitter_region += [5, 6, 7, 8, 9]
##		form.glitter_region = [1,0,2,3,4,5,6,7,8,9]
#	if swap_region == 5:
#		form.glitter_region = [2, 0, 1, 3, 4]
#		form.glitter_region += [10, 11, 12, 13, 14]
##		form.glitter_region = [2,0,1,3,4,10,11,12,13,14]
#	if swap_region == 6:
#		form.glitter_region = [6, 5, 7, 8, 9]
#		form.glitter_region += [10, 11, 12, 13, 14]
##		form.glitter_region = [6,5,7,8,9,10,11,12,13,14]

	for glitter_index in form.glitter_region:
		form.extended_type_palettes[type.id][index] = type_palette[glitter_index]
		form.extended_type_palettes[type.id][glitter_index] = type_palette[index]
		index += 1

func swap_astral_palette(swap_region):
	var form = monster_forms[monster_button.get_selected_id()]
	var type = ElementalTypes.table.values()[coating_button.get_selected_id()]	
	var type_palette = form.extended_type_palettes[type.id].duplicate()
	var index:int = 0
	if swap_region == 0:
		form.astral_region = [0,1,2,3,4]
	if swap_region == 1:
		form.astral_region = [5,6,7,8,9]
	if swap_region == 2:
		form.astral_region = [10,11,12,13,14]
	if swap_region == 3:
		form.astral_region = [15,16,17,18,19]
#		form.astral_region = [15,16,17,18,19,20,21,22,23,24,25,26,27,28,29]
#	if swap_region == 4:
#		form.astral_region = [20,21,22,23,24,5,6,7,8,9]
#	if swap_region == 4:
#		form.astral_region = [0,1,2,3,4,5,6,7,8,9]
#	if swap_region == 5:
#		form.astral_region = [0,1,2,3,4,10,11,12,13,14]
#	if swap_region == 6:
#		form.astral_region = [5,6,7,8,9,10,11,12,13,14]

			
	for astral_index in form.astral_region:
		form.extended_type_palettes[type.id][index] = type_palette[astral_index]
		form.extended_type_palettes[type.id][astral_index] = type_palette[index]
		index += 1

func _on_ResetPalette_pressed():
	if yield(MenuHelper.confirm("Are you sure you want to reset this palette?"),"completed"):
		var form = monster_forms[monster_button.get_selected_id()]	
		var type
		if not coating_button.get_selected_id() == ElementalTypes.table.values().size():	
			type = ElementalTypes.table.values()[coating_button.get_selected_id()]	
			form.extended_type_palettes[type.id] = form.swap_colors.duplicate()
		else:
			type = "Default"
			form.default_palette = form.swap_colors.duplicate()
			slot.set_form(null)
		update_selection()
		yield (GlobalMessageDialog.show_message("Color palette reset to " + Loc.tr(form.name) + "'s current default palette."),"completed")	


func _on_LinkEvo_pressed():
	if not has_project_info(get_current_monster_name()):
		yield(GlobalMessageDialog.show_message("Your existing bootleg mod does not have a project entry. Please input the name(case sensitive) of this mod's folder."),"completed")
		mod_name = yield(MenuHelper.show_text_input("Existing Mod Name", mod_name),"completed")
		set_project_info(get_current_monster_name())		
	if yield(MenuHelper.confirm("Forms related to %s found in the %s folder will update to use this as their Remaster. Continue?"%[get_current_monster_name(),mod_name]),"completed"):
		var mod_path = "res://mods/"
		var mod_files = Datatables.load(mod_path+mod_name).table
		var selected_form = monster_forms[monster_button.get_selected_id()]
		var extended_monster_file = mod_path+"/"+mod_name+"/"+get_current_monster_name()+"_ext.tres"
		var message:String = "Changed files: \n"
		for file in mod_files.values():
			if file is MonsterForm:
				for evo in file.evolutions:
					if evo.evolved_form.name == selected_form.name:
						evo.evolved_form = load(extended_monster_file)
						var err = ResourceSaver.save(file.resource_path, file)
						if err == OK:
							message += "Updated %s \n"%file.resource_path 
							break
		yield(GlobalMessageDialog.show_message(message),"completed")
