extends BattleSlot

func transform_to(form:BaseForm, palette:Array = [], sparkle = null, idle_override:String = ""):

	sprite_container.push_params()

	var was_fusion:bool = self.form is FusionForm
	var is_fusion:bool = form is FusionForm
	var is_human:bool = not form is MonsterForm and not form is FusionForm
	var was_monster:bool = self.form is MonsterForm
	
	if self.form != null:
		if was_monster and is_human and not was_fusion and not is_fusion and not get_fighter().is_fusion() and not get_fighter().status.has_tag("recording"):
			play_form_sound("battle_cry", 0.667)
			print("Playing Defeated Cry")
			yield (play_slot_animation("transform_out"), "completed")
		else:
			yield (play_slot_animation("transform_out"), "completed")
			print("Not Dead")
	sprite_container.pop_params()
	set_form(form, idle_override)
	set_palette(palette, false)
	if sparkle != null:
		set_sparkle(sparkle)
	sprite_container.push_params()
	if form != null:
		if get_fighter().get_character_kind() == Character.CharacterKind.HUMAN and was_monster and is_fusion:
			yield (play_slot_animation("transform_in"), "completed")
			print("Fusing")
			
		elif get_fighter().get_character_kind() == Character.CharacterKind.HUMAN and not is_human:
			yield (play_slot_animation("transform_in"), "completed")
			play_slot_animation("monster_battle_cry")
#			yield (play_slot_animation("monster_battle_cry"), "completed")
			print("Playing Battle Cry")

		else:
			yield (play_slot_animation("transform_in"), "completed")
			print("Not Monster")
	sprite_container.pop_params()
