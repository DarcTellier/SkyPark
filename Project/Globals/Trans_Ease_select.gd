extends Node


func select_trans(trans_select):
	#make these globals  as well as ease 
	match trans_select:
		0: return Tween.TRANS_BACK
		1: return Tween.TRANS_BOUNCE
		2: return Tween.TRANS_CIRC
		3: return Tween.TRANS_CUBIC
		4: return Tween.TRANS_ELASTIC
		5: return Tween.TRANS_EXPO
		6: return Tween.TRANS_LINEAR
		7: return Tween.TRANS_QUAD
		8: return Tween.TRANS_QUART
		9: return Tween.TRANS_QUINT
		10: return Tween.TRANS_SINE


func select_ease(ease_select):
	match ease_select:
		0:return Tween.EASE_IN
		1:return Tween.EASE_IN_OUT
		2:return Tween.EASE_OUT
		3:return Tween.EASE_OUT_IN
