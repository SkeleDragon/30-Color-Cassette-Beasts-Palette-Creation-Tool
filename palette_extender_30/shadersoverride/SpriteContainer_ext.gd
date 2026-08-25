tool 
extends SpriteContainer

const AsepriteController_ext = preload("res://mods/zSkele_Bootlegs/shadersoverride/AsepriteController_ext.gd")

func _create_controller():
	if scene is LayeredSprite3D:
		return LayeredSpriteController.new(scene)
	if scene is Spatial and scene.has_node(NodePath("Sprite3D")) and scene.has_node(NodePath("AnimationPlayer")):
		return AsepriteController_ext.new(scene as Spatial)
	if scene is Spatial and scene.has_node(NodePath("Sprite3D")) and scene.has_node(NodePath("Viewport")) and scene.get_node(NodePath("Viewport")).get_child_count() > 0 and scene.get_node(NodePath("Viewport")).get_child(0).has_node(NodePath("AnimationPlayer")):
		return ViewportController.new(scene as Spatial)
	push_warning("No suitable controller for SpriteContainer")
	return null
