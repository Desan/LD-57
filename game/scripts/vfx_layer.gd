extends CanvasLayer
#
#@onready var crt_effect: ColorRect = $CRTEffect
#@onready var underwater_effect: ColorRect = $UnderwaterEffect
#
#func _process(delta):
	#var mat := underwater_effect.material
	#if mat and mat is ShaderMaterial:
		#mat.set("shader_paramater/rtime", Time.get_ticks_msec() / 1000.0)
